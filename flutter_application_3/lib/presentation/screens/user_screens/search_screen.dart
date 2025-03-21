import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/presentation/widgets/plates_list_view.dart';
import 'package:flutter_application_example/presentation/widgets/rest_list_view.dart';

class SearchScreen extends StatefulWidget {
  final List<Plate> allPlates;
  final List<Restaurant> allRestaurants;

  const SearchScreen({super.key, required this.allPlates, required this.allRestaurants});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";

  List<Plate> _filterPlates() {
    return widget.allPlates.where((plate) {
      return plate.name.toLowerCase().contains(query.toLowerCase()) ||
             plate.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

//BUSQUEDA SOLO POR NOMBRE DE PLATOS EN RESTAURANTES
  List<Restaurant> _filterRestaurants() {
    return widget.allRestaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
             widget.allPlates.any((plate) => plate.cartId == restaurant.restaurantId && 
                (plate.name.toLowerCase().contains(query.toLowerCase())));
    }).toList();
  }

  /*
  BUSQUEDA OPCIONAL 
  List<Restaurant> _filterRestaurants() {
  return widget.allRestaurants.where((restaurant) {
    return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.description?.toLowerCase().contains(query.toLowerCase()) == true ||
            widget.allPlates.any((plate) => plate.cartId == restaurant.restaurantId && 
              (plate.name.toLowerCase().contains(query.toLowerCase()) ||
                plate.description.toLowerCase().contains(query.toLowerCase())));
  }).toList();
}

*/

  @override
  Widget build(BuildContext context) {
    final filteredPlates = _filterPlates();
    final filteredRestaurants = _filterRestaurants();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Platos y Restaurantes"),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar platos o restaurantes...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (filteredPlates.isNotEmpty)
                    ...filteredPlates
                        .map((plate) => _buildRestaurantWithPlates(plate))
                        .toList(),
                  if (filteredRestaurants.isNotEmpty) ...[
                    const SectionTitle(title: "RESTAURANTES CON ESTOS PLATOS"),
                    RestaurantsListView(restaurants: filteredRestaurants),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantWithPlates(Plate plate) {
    final restaurant = widget.allRestaurants.firstWhere(
      (res) => res.restaurantId == plate.cartId,
      orElse: () => Restaurant(restaurantId: 0, name: "Desconocido", location: "N/A", contactNumber: "N/A", horario: "N/A", idDueno: "N/A", createdAt: DateTime.now()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: restaurant.name),
        PlatesListView(plates: [plate]),
      ],
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
