import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantBottomSheet extends StatelessWidget {
  final Restaurant restaurant;
  final Position currentPosition;
  final VoidCallback onNavigate;

  const RestaurantBottomSheet({
    super.key,
    required this.restaurant,
    required this.currentPosition,
    required this.onNavigate,
  });

  String _formatDistance(double distance) {
    return distance >= 1000
        ? "${(distance / 1000).toStringAsFixed(2)} km"
        : "${distance.toStringAsFixed(0)} m";
  }

  void _openInGoogleMaps() async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${restaurant.coordinates?.latitude},${restaurant.coordinates?.longitude}",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("No se pudo abrir Google Maps.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double distance = 0;
    if (restaurant.coordinates != null) {
      distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        restaurant.coordinates!.latitude,
        restaurant.coordinates!.longitude,
      );
    }

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.2,
            maxChildSize: 0.5,
            expand: false, // Permite que desaparezca al deslizarlo
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(restaurant.category ?? "Sin categoría"),
                      const SizedBox(height: 10),
                      Text("Distancia: ${_formatDistance(distance)}"),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          restaurant.imageOfLocal ?? "https://via.placeholder.com/400x200",
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: onNavigate,
                            child: const Text("Cómo Llegar"),
                          ),
                          ElevatedButton(
                            onPressed: _openInGoogleMaps,
                            child: const Text("Abrir en Maps"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
