import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/plate_provider_prueba.dart';

class PlateDetailScreen extends StatelessWidget {
  final Plate plate;
   
  const PlateDetailScreen({super.key, required this.plate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(plate.name),
    );
  }
}