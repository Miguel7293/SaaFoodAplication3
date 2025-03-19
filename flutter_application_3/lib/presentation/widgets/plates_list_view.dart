import 'package:flutter/material.dart';
import 'card_plates.dart';
import '../../data/models/plate_provider_prueba.dart';

class PlatesListView extends StatelessWidget {
  final List<Plate> plates;

  const PlatesListView({super.key, required this.plates});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        itemCount: plates.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: CardPlates(plate: plates[index])
        ),
      ),
    );
  }
}
