import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
