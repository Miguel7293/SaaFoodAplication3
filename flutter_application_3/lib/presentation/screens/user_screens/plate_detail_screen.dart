import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/presentation/theme/styles.dart';

class PlateDetailScreen extends StatelessWidget {
  final Plate plate; 

  const PlateDetailScreen({super.key, required this.plate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(plate.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCachedImage(plate.image),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              plate.name,
              style: AppStyles.tittleTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              plate.description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Precio: S/. ${plate.price.toStringAsFixed(2)}",
              style: AppStyles.secondaryTextStyle,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                style: AppStyles.buttonStyle(AppColors.descriptionPrimary),
                child: Text("Ir a Restaurante"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCachedImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: 250, 
      fit: BoxFit.cover,
      memCacheWidth: 800, //se iguala al anterior cache size
      placeholder: (context, url) => Container(
        height: 250,
        color: Colors.grey[300],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error, size: 50, color: Colors.red)),
    );
  }
}
