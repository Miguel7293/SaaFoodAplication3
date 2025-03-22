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
  List<LatLng>? _lastRoute; // Última ruta guardada
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
    _trackUserLocation(); // 🔹 Comienza el seguimiento en tiempo real
  }

  void dispose() {
    _isDisposed = true;
    _mapController?.dispose();
    _positionStream?.cancel();
  }

  Future<void> _getUserLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (!_isDisposed) {
      _currentPosition = position;
      updateUI();
    }
  }

  Future<void> _loadRestaurants() async {
    try {
      final restaurants = await _restaurantRepo.getAllRestaurants();
      if (!_isDisposed) {
        markers.addAll(restaurants
            .where((r) => r.coordinates != null)
            .map((r) => _createMarker(
                  r.restaurantId.toString(),
                  LatLng(r.coordinates!.latitude, r.coordinates!.longitude),
                  r.name,
                  BitmapDescriptor.hueRed,
                  r,
                )));
        updateUI();
      }
    } catch (e) {
      print("❌ Error al cargar restaurantes: $e");
    }
  }

  Marker _createMarker(String id, LatLng position, String title, double hue,
      [Restaurant? restaurant]) {
    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: InfoWindow(title: title),
      onTap: restaurant != null ? () => _selectRestaurant(restaurant) : null,
    );
  }

  void _selectRestaurant(Restaurant restaurant) {
    if (_currentPosition == null || _isDisposed) return;
    showRestaurantDetails(restaurant);
  }

  Position? getCurrentPosition() => _currentPosition;

  Future<void> drawRoute(LatLng destination) async {
    if (_currentPosition == null || _isDisposed) return;

    _destination = destination;

    try {
      final route = await _mapService.getRoute(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          destination);

      if (!_isDisposed) {
        _lastRoute = route; // 🔹 Guarda la última ruta calculada
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
      print("❌ Error al obtener ruta: $e");
    }
  }

  void _trackUserLocation() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // 🔹 Actualiza si se mueve más de 5 metros
      ),
    ).listen((Position position) {
      if (_isDisposed) return;

      _currentPosition = position;
      updateUI();

      if (_destination != null) {
        double distanceToDestination = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          _destination!.latitude,
          _destination!.longitude,
        );

        // 🔹 Si está a menos de 10 metros, elimina la ruta
        if (distanceToDestination < 10) {
          showMessage("¡Has llegado a tu destino! 🎉");
          polylines.clear(); // 🔹 Borra la ruta
          _destination = null; // 🔹 Resetea el destino
          _lastRoute = null; // 🔹 Limpia la última ruta
          updateUI();
          return;
        }

        // 🔹 Verifica si se desvió más de 50 metros
        if (_lastRoute != null) {
          double minDistanceToRoute = _lastRoute!
              .map((point) => Geolocator.distanceBetween(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                    point.latitude,
                    point.longitude,
                  ))
              .reduce((a, b) => a < b ? a : b);

          if (minDistanceToRoute > 50) {
            print("🔄 Usuario desviado +50m, recalculando ruta...");
            drawRoute(_destination!);
          }
        }
      }
    });
  }
}
