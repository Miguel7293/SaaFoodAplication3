import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'card_plates_owner.dart';

class PlatesListViewOwner extends StatelessWidget {
  final List<Plate> plates;

  const PlatesListViewOwner({super.key, required this.plates});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 215,
      child: ListView.builder(
        itemCount: plates.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: CardPlatesOwner(plate: plates[index])
        ),
      ),
    );
  }
}
