import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/presentation/screens/user_screens/search_screen.dart';
import 'package:flutter_application_example/presentation/widgets/search_app_bar.dart';
import 'package:provider/provider.dart';
import '../../widgets/rest_list_view.dart';
import '../../../data/services/restaurant_repository.dart';
import '../../widgets/plates_list_view.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  Future<Map<String, dynamic>> _fetchData(BuildContext context) async {
    final restaurantRepo = Provider.of<RestaurantRepository>(context, listen: false);
    final plateRepo = PlateRepository();

    final restaurants = await restaurantRepo.getAllRestaurants();
    final bestRestaurants = await restaurantRepo.getTopRatedRestaurants();
    final plates = await plateRepo.getAllPlates();
    final pricedPlates = await plateRepo.getBestPricedPlates();

    return {
      'restaurants': restaurants,
      'topRatedRestaurants': bestRestaurants,
      'allPlates': plates,
      'bestPricedPlates': pricedPlates,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "SA Foods",
        onSearchPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureBuilder<Map<String, dynamic>>(
                future: _fetchData(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(child: Text("Error al cargar datos"));
                  }
                  return SearchScreen(
                    allPlates: snapshot.data!['allPlates'],
                    allRestaurants: snapshot.data!['restaurants'],
                  );
                },
              ),
            ),
          );
        },
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error al cargar datos"));
          }

          final data = snapshot.data!;
          return ListView.builder(
            key: const PageStorageKey<String>('user_home_screen'),
            padding: const EdgeInsets.only(bottom: 180),
            cacheExtent: 600, // Resolucion de imagen en cache
            itemCount: 3,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    const SectionTitle(title: "RESTAURANTES RECOMENDADOS"),
                    RestaurantsListView(restaurants: data['topRatedRestaurants']),
                  ],
                );
              } else if (index == 1) {
                return Column(
                  children: [
                    const SectionTitle(title: "MEJORES PRECIOS"),
                    PlatesListView(plates: data['bestPricedPlates']),
                  ],
                );
              } else {
                return Column(
                  children: [
                    const SectionTitle(title: "PLATOS CERCA DE TI"),
                    PlatesListView(plates: data['allPlates']),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}
