import 'package:flutter/material.dart';
import 'package:flutter_application_example/components/plates_list_view.dart';
import 'package:flutter_application_example/components/rest_list_view.dart';
import 'package:flutter_application_example/data/plate_provider_prueba.dart';
import 'package:flutter_application_example/data/rest_provider_prueba.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final myplates = PlateProvider.plates;
  final myrest = RestaurantProvider.restaurants;
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Text("HOT DEALS"),
        PlatesListView(plates: PlateProvider.plates),
        Text("RECOMENDATIONS"),
        PlatesListView(plates: PlateProvider.plates), //SI VEN ESTO ES PARA USAR EL SCROLL HORIZONTAL DE PLATOS
        Text("RESTAURANTES CERCANOS"),
        RestaurantsListView(restaurants: myrest)
      ]
    );
  }
}
