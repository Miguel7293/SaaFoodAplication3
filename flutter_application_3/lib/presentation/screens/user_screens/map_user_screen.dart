import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/services/map_controller.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/presentation/widgets/rest_bottom_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUserScreen extends StatefulWidget {
  const MapUserScreen({super.key});

  @override
  State<MapUserScreen> createState() => _MapUserScreenState();
}

class _MapUserScreenState extends State<MapUserScreen> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      updateUI: () => setState(() {}),
      showRestaurantDetails: _showRestaurantDetails,
      showMessage: _showMessage,
    );
    _mapController.initialize();
  }

  void _showRestaurantDetails(Restaurant restaurant) {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => RestaurantDetails(
        restaurant,
        _mapController.getCurrentPosition()!,
        _mapController.drawRoute,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Restaurantes")),
      body: GoogleMap(
        initialCameraPosition: _mapController.initialCameraPosition,
        markers: _mapController.markers,
        polylines: _mapController.polylines,
        onMapCreated: _mapController.setMapController,
        myLocationEnabled: true, // 🔹 Activa el punto azul
        myLocationButtonEnabled: true,
      ),
    );
  }
}
