import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/data/services/map_service.dart';
import 'package:flutter_application_example/data/services/restaurant_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapController {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  StreamSubscription<Position>? _positionStream;
  LatLng? _destination;
  List<LatLng>? _lastRoute;
  final RestaurantRepository _restaurantRepo = RestaurantRepository();
  final MapService _mapService = MapService();
  final LatLng _initialPosition = const LatLng(-15.8402, -70.0219);
  final Function updateUI;
  final Function(Restaurant) showRestaurantDetails;
  final Function(String) showMessage;
  bool _isDisposed = false;

  MapController({
    required this.updateUI,
    required this.showRestaurantDetails,
    required this.showMessage,
  });

  CameraPosition get initialCameraPosition =>
      CameraPosition(target: _initialPosition, zoom: 14);

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void initialize() async {
    await _getUserLocation();
    await _loadRestaurants();
    _trackUserLocation();
  }

  void dispose() {
    _isDisposed = true;
    _mapController?.dispose();
    _positionStream?.cancel();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showMessage("La ubicación está desactivada. Actívala para usar esta función.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showMessage("Permiso de ubicación denegado.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showMessage("Los permisos de ubicación están bloqueados. Actívalos en configuración.");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!_isDisposed) {
        _currentPosition = position;
        updateUI();
      }
    } catch (e) {
      showMessage("Error al obtener ubicación: ${e.toString()}");
      _currentPosition = null; // Asegurar que sea null en caso de error
    }
  }

  Future<void> _loadRestaurants() async {
    try {
      final restaurants = await _restaurantRepo.getAllRestaurants();
      if (!_isDisposed) {
        markers = restaurants
            .where((r) => r.coordinates != null)
            .map((r) => _createMarker(
                  r.restaurantId.toString(),
                  LatLng(r.coordinates!.latitude, r.coordinates!.longitude),
                  r.name,
                  BitmapDescriptor.hueRed,
                  r,
                ))
            .toSet();
        updateUI();
      }
    } catch (e) {
      showMessage("Error al cargar restaurantes");
      markers = {}; // Limpiar marcadores en caso de error
    }
  }

  Marker _createMarker(String id, LatLng position, String title, double hue,
      [Restaurant? restaurant]) {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: InfoWindow(title: title),
      onTap: restaurant != null 
          ? () => _selectRestaurant(restaurant) 
          : null,
    );
  }

  void _selectRestaurant(Restaurant restaurant) {
    if (_isDisposed) return;
    
    
    if (restaurant.coordinates == null) {
      showMessage("Este restaurante no tiene ubicación registrada.");
      return;
    }
    
    showRestaurantDetails(restaurant);
  }

  Position? getCurrentPosition() => _currentPosition;

  Future<void> drawRoute(LatLng destination) async {
    if (_isDisposed) return;
    
    if (_currentPosition == null) {
      showMessage("No se puede calcular la ruta. Activa la ubicación.");
      return;
    }

    _destination = destination;

    try {
      final route = await _mapService.getRoute(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        destination,
      );

      if (!_isDisposed) {
        _lastRoute = route;
        polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            color: Colors.blue,
            width: 5,
            points: route,
          ),
        };
        updateUI();
      }
    } catch (e) {
      showMessage("Error al calcular la ruta: ${e.toString()}");
      polylines.clear();
      _destination = null;
      _lastRoute = null;
    }
  }

  void _trackUserLocation() {
    _positionStream?.cancel(); // Cancelar cualquier suscripción previa
    
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      if (_isDisposed) return;

      _currentPosition = position;
      updateUI();

      if (_destination == null) return;

      try {
        double distanceToDestination = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          _destination!.latitude,
          _destination!.longitude,
        );

        if (distanceToDestination < 10) {
          showMessage("¡Has llegado a tu destino! 🎉");
          polylines.clear();
          _destination = null;
          _lastRoute = null;
          updateUI();
          return;
        }

        if (_lastRoute != null) {
          double minDistanceToRoute = _lastRoute!
              .map((point) => Geolocator.distanceBetween(
                    position.latitude,
                    position.longitude,
                    point.latitude,
                    point.longitude,
                  ))
              .reduce((a, b) => a < b ? a : b);

          if (minDistanceToRoute > 50) {
            showMessage("Te has desviado, recalculando ruta...");
            drawRoute(_destination!);
          }
        }
      } catch (e) {
        print("Error en seguimiento de ubicación: $e");
      }
    }, onError: (e) {
      showMessage("Error en seguimiento de ubicación");
      _currentPosition = null;
    });
  }
}