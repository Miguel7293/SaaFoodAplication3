import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/presentation/theme/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetails extends StatelessWidget {
  final Restaurant restaurant;
  final Position? userPosition; // Cambiado a nullable
  final Function(LatLng) onNavigate;

  const RestaurantDetails(this.restaurant, this.userPosition, this.onNavigate,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasUserLocation = userPosition != null;
    final bool hasRestaurantLocation = restaurant.coordinates != null;
    final bool canCalculateDistance = hasUserLocation && hasRestaurantLocation;

    final double? distance = canCalculateDistance
        ? Geolocator.distanceBetween(
            userPosition!.latitude,
            userPosition!.longitude,
            restaurant.coordinates!.latitude,
            restaurant.coordinates!.longitude,
          )
        : null;

    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 0.4,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
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
                  if (distance != null)
                    Text("Distancia: ${_formatDistance(distance)}")
                  else if (!hasUserLocation)
                    Text("No se pudo obtener tu ubicación",
                        style: const TextStyle(color: Colors.red))
                  else if (!hasRestaurantLocation)
                    Text("El restaurante no tiene ubicación registrada",
                        style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  AppStyles.detailImage(restaurant.imageOfLocal),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style:
                            AppStyles.buttonStyle(AppColors.descriptionPrimary),
                        onPressed: hasRestaurantLocation && hasUserLocation
                            ? () => onNavigate(LatLng(
                                restaurant.coordinates!.latitude,
                                restaurant.coordinates!.longitude))
                            : null,
                        child: const Text("Cómo llegar"),
                      ),
                      ElevatedButton(
                        style:
                            AppStyles.buttonStyle(AppColors.descriptionPrimary),
                        onPressed: hasRestaurantLocation
                            ? () => _openInGoogleMaps(restaurant)
                            : null,
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
    if (restaurant.coordinates == null) return;

    final url =
        "https://www.google.com/maps/search/?api=1&query=${restaurant.coordinates!.latitude},${restaurant.coordinates!.longitude}";
    launchUrl(Uri.parse(url));
  }
}
