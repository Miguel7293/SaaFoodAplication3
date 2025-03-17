import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/main_colors.dart';
import 'package:flutter_application_example/data/plate_provider_prueba.dart';

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
          Image.network(plate.image,
              width: double.infinity, height: 200, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              plate.name,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.descriptionPrimary),
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(AppColors.descriptionPrimary),
                  foregroundColor: WidgetStateProperty.all(
                      Colors.white),
                ),
                child: Text("Ir a Restaurante"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
