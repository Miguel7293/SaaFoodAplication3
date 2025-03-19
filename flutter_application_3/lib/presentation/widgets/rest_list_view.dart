import 'package:flutter/material.dart';
import 'card_rest.dart';
import 'package:flutter_application_example/data/models/restaurant.dart'; // Usa el modelo correcto

class RestaurantsListView extends StatelessWidget {
  final List<Restaurant> restaurants;

  const RestaurantsListView({super.key, required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Altura del contenedor
      child: ListView.builder(
        itemCount: restaurants.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => RestaurantCard(res: restaurants[index]),
      ),
    );
  }
}
