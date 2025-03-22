import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/presentation/theme/styles.dart';
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

    return DraggableScrollableSheet(
      initialChildSize: 1, // Comienza ocupando el 60% de la pantalla
      minChildSize: 0.4, // Se puede reducir hasta el 30%
      maxChildSize: 1, // Se puede expandir hasta el 90%
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController, // Vincula el scroll con el deslizable
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Text(restaurant.name, style: AppStyles.primaryTextStyle),
                  Text(restaurant.category ?? "Sin categoría"),
                  const SizedBox(height: 10),
                  Text("Distancia: ${_formatDistance(distance)}"),
                  const SizedBox(height: 10),
                  AppStyles.detailImage(restaurant.imageOfLocal),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: AppStyles.primaryButtonStyle,
                        onPressed: () => onNavigate(LatLng(
                            restaurant.coordinates!.latitude,
                            restaurant.coordinates!.longitude)),
                        child: const Text("Cómo Llegar"),
                      ),
                      ElevatedButton(
                        style: AppStyles.primaryButtonStyle,
                        onPressed: () => _openInGoogleMaps(restaurant),
                        child: const Text("Abrir en Maps"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
