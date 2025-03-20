import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUserScreen extends StatefulWidget {
  const MapUserScreen({super.key});

  @override
  State<MapUserScreen> createState() => _MapUserScreenState();
}

class _MapUserScreenState extends State<MapUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa")),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-12.0464, -77.0428), // Ubicación en Lima, Perú
          zoom: 14,
        ),
      ),
    );
  }
}
