import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/presentation/widgets/plates_list_view.dart';
import 'package:provider/provider.dart';
import '../../widgets/rest_list_view.dart';
import '../../../data/services/restaurant_repository.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Provider.of<RestaurantRepository>(context, listen: false).getAllRestaurants(),
        PlateRepository().getAllPlates(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final restaurants = (snapshot.data?[0] as List).map((e) => e as Restaurant).toList();
        final plates = snapshot.data?[1] as List<Plate>? ?? [];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: "HOT DEALS"),
              PlatesListView(plates: plates), 
              const SectionTitle(title: "RECOMMENDATIONS"),
              PlatesListView(plates: plates), 
              const SectionTitle(title: "RESTAURANTES CERCANOS"),
              RestaurantsListView(restaurants: restaurants),
              SizedBox(height: 180)
            ],
          ),
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
