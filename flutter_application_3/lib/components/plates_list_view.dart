import 'package:flutter/material.dart';
import 'package:flutter_application_example/components/card_plates.dart';
import 'package:flutter_application_example/data/plate_provider_prueba.dart'; // Importa la clase Plate

class PlatesListView extends StatelessWidget {
  final List<Plate> plates;

  const PlatesListView({super.key, required this.plates});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        itemCount: plates.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: CardPlates(
            image: plates[index].image,
            name: plates[index].name,
          ),
        ),
      ),
    );
  }
}
