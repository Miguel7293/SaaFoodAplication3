import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/plate_provider_prueba.dart';
import 'package:flutter_application_example/presentation/widgets/plates_list_view.dart';
import 'package:provider/provider.dart';
import '../../widgets/rest_list_view.dart';
import '../../../data/services/restaurant_repository.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<RestaurantRepository>(context, listen: false)
          .getAllRestaurants(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final restaurants = snapshot.data ?? [];

        return Column(
          children: [
            Text("HOT DEALS"),
            PlatesListView(plates: PlateProvider.plates),
            Text("RECOMENDATIONS"),
            PlatesListView(
                plates: PlateProvider
                    .plates), //SI VEN ESTO ES PARA USAR EL SCROLL HORIZONTAL DE PLATOS
            const Text("RESTAURANTES CERCANOS"),
            RestaurantsListView(restaurants: restaurants),
          ],
        );
      },
    );
  }
}
