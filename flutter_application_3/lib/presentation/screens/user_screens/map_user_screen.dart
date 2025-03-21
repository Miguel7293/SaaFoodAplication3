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
  late GoogleMapController mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _selectedRestaurant;
  Restaurant? _restaurantDetails;
  final LatLng _initialPosition = const LatLng(-15.8402, -70.0219);
  final RestaurantRepository _restaurantRepo = RestaurantRepository();
  final MapService _mapService = MapService();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _loadRestaurants();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });

    _addUserMarker();
  }

  void _addUserMarker() {
    if (_currentPosition != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId("current_location"),
            position:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: "Tu ubicación"),
          ),
        );
      });
    }
  }

  Future<void> _loadRestaurants() async {
    try {
      List<Restaurant> restaurants = await _restaurantRepo.getAllRestaurants();

      setState(() {
        _markers.addAll(
          restaurants
              .where((restaurant) => restaurant.coordinates != null)
              .map((restaurant) {
            final latLng = restaurant.coordinates!;

            return Marker(
              markerId: MarkerId(restaurant.restaurantId.toString()),
              position: LatLng(latLng.latitude, latLng.longitude),
              infoWindow: InfoWindow(
                title: restaurant.name,
                snippet: restaurant.category ?? "Sin categoría",
              ),
              onTap: () => _showRestaurantDetails(restaurant),
            );
          }),
        );
      });
    } catch (e) {
      print("❌ Error al cargar restaurantes: $e");
    }
  }

  void _showRestaurantDetails(Restaurant restaurant) {
    if (_currentPosition == null) return;

    final double distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      restaurant.coordinates!.latitude,
      restaurant.coordinates!.longitude,
    );

    setState(() {
      _selectedRestaurant = LatLng(
        restaurant.coordinates!.latitude,
        restaurant.coordinates!.longitude,
      );
      _restaurantDetails = restaurant;
    });

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildBottomSheet(distance);
      },
    );
  }

  Widget _buildBottomSheet(double distance) {
    if (_restaurantDetails == null) return Container();

    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _restaurantDetails!.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(_restaurantDetails!.category ?? "Sin categoría"),
          const SizedBox(height: 10),
          Text("Distancia: ${_formatDistance(distance)}"),
          const SizedBox(height: 10),
          Image.network(
            _restaurantDetails!.imageOfLocal ??
                "https://via.placeholder.com/400x200",
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _drawRouteToRestaurant,
                child: const Text("Como Llegar"),
              ),
              ElevatedButton(
                onPressed: _openInGoogleMaps,
                child: const Text("Abrir en Maps"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDistance(double distance) {
    return distance >= 1000
        ? "${(distance / 1000).toStringAsFixed(2)} km"
        : "${distance.toStringAsFixed(0)} m";
  }

  Future<void> _drawRouteToRestaurant() async {
    if (_currentPosition == null || _selectedRestaurant == null) return;

    try {
      List<LatLng> route = await _mapService.getRoute(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        _selectedRestaurant!,
      );

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
    } catch (e) {
      print("❌ Error al obtener ruta: $e");
    }
  }

  void _openInGoogleMaps() {
    if (_selectedRestaurant == null) return;
    final url =
        "https://www.google.com/maps/search/?api=1&query=${_selectedRestaurant!.latitude},${_selectedRestaurant!.longitude}";
    launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Restaurantes")),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _initialPosition, zoom: 14),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) => mapController = controller,
      ),
    );
  }
}
