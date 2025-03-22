import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/presentation/widgets/card_with_plate.dart';

class CartasTab extends StatelessWidget {
  final Restaurant res;

  const CartasTab({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: CartaWithPlatesWidget(restaurant: res),
    );
  }
}
