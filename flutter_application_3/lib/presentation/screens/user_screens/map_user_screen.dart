import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/services/map_controller.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/presentation/theme/styles.dart';
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

    final userPosition = _mapController.getCurrentPosition();


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              builder: (context, scrollController) {
                return ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    color: Colors.transparent,
                    child: RestaurantDetails(
                      restaurant,
                      userPosition,
                      _mapController.drawRoute,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
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
      appBar: AppStyles.appBar("Mapa de restaurantes"),
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
