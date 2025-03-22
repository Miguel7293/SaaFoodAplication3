import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/data/services/map_service.dart';
import 'package:flutter_application_example/data/services/restaurant_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUserScreen extends StatefulWidget {
  const MapUserScreen({super.key});

  @override
  State<MapUserScreen> createState() => _MapUserScreenState();
}

class _MapUserScreenState extends State<MapUserScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Restaurant? _selectedRestaurant;
  final _restaurantRepo = RestaurantRepository();
  final _mapService = MapService();
  final _initialPosition = const LatLng(-15.8402, -70.0219);
  bool _isDisposed = false; // Flag para evitar setState() después de dispose

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    await _getUserLocation();
    await _loadRestaurants();
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

    if (mounted) {
      setState(() {
        _currentPosition = position;
        _markers.add(_createMarker(
          "current_location",
          LatLng(position.latitude, position.longitude),
          "Tu ubicación",
          BitmapDescriptor.hueBlue,
        ));
      });
    }
  }

  Future<void> _loadRestaurants() async {
    try {
      final restaurants = await _restaurantRepo.getAllRestaurants();
      if (mounted) {
        setState(() {
          _markers.addAll(restaurants
              .where((r) => r.coordinates != null)
              .map((r) => _createMarker(
                  r.restaurantId.toString(),
                  LatLng(r.coordinates!.latitude, r.coordinates!.longitude),
                  r.name,
                  BitmapDescriptor.hueRed,
                  r)));
        });
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
    if (_currentPosition == null) return;

    if (mounted) {
      setState(() => _selectedRestaurant = restaurant);
    }
    
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          RestaurantDetails(restaurant, _currentPosition!, _drawRoute),
    );
  }

  Future<void> _drawRoute(LatLng destination) async {
    if (_currentPosition == null || _isDisposed) return;

    try {
      final route = await _mapService.getRoute(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          destination);

      if (mounted) {
        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId("route"),
              color: Colors.blue,
              width: 5,
              points: route,
            ),
          };
        });
      }
    } catch (e) {
      print("❌ Error al obtener ruta: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Restaurantes")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 14),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}

class RestaurantDetails extends StatelessWidget {
  final Restaurant restaurant;
  final Position userPosition;
  final Function(LatLng) onNavigate;

  const RestaurantDetails(this.restaurant, this.userPosition, this.onNavigate,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final distance = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      restaurant.coordinates!.latitude,
      restaurant.coordinates!.longitude,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(restaurant.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(restaurant.category ?? "Sin categoría"),
          const SizedBox(height: 10),
          Text("Distancia: ${_formatDistance(distance)}"),
          const SizedBox(height: 10),
          Image.network(
            restaurant.imageOfLocal ?? "https://via.placeholder.com/400x200",
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => onNavigate(LatLng(
                    restaurant.coordinates!.latitude,
                    restaurant.coordinates!.longitude)),
                child: const Text("Cómo Llegar"),
              ),
              ElevatedButton(
                onPressed: () => _openInGoogleMaps(restaurant),
                child: const Text("Abrir en Maps"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDistance(double distance) {
    return distance >= 1000
        ? "${(distance / 1000).toStringAsFixed(2)} km"
        : "${distance.toStringAsFixed(0)} m";
  }

  static void _openInGoogleMaps(Restaurant restaurant) {
    final url =
        "https://www.google.com/maps/search/?api=1&query=${restaurant.coordinates!.latitude},${restaurant.coordinates!.longitude}";
    launchUrl(Uri.parse(url));
  }
}
