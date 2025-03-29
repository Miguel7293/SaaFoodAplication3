import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/data/services/provider/data_provider.dart';
import 'package:flutter_application_example/presentation/theme/styles.dart';
import 'package:flutter_application_example/presentation/widgets/plates_list_view.dart';
import 'package:flutter_application_example/presentation/widgets/rest_list_view.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  final List<Plate> allPlates;
  final List<Restaurant> allRestaurants;

  const SearchScreen({super.key, required this.allPlates, required this.allRestaurants});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  List<Plate> _filterPlates(List<Plate> plates) {
    return plates.where((plate) {
      return plate.name.toLowerCase().contains(query.toLowerCase()) ||
          plate.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  List<Restaurant> _filterRestaurants(List<Restaurant> restaurants, List<Plate> plates) {
    return restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
          plates.any((plate) =>
              plate.cartId == restaurant.restaurantId &&
              plate.name.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    final plates = widget.allPlates.isNotEmpty ? widget.allPlates : dataProvider.allPlates;
    final restaurants = widget.allRestaurants.isNotEmpty ? widget.allRestaurants : dataProvider.restaurants;

    final filteredPlates = _filterPlates(plates);
    final filteredRestaurants = _filterRestaurants(restaurants, plates);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppStyles.appBar("Buscar Platos y Restaurantes"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
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
          if (query.isNotEmpty) // Solo muestra los resultados si hay búsqueda
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filteredPlates.isNotEmpty)
                      ...filteredPlates.map((plate) => _buildRestaurantWithPlates(plate, restaurants)).toList(),
                    if (filteredRestaurants.isNotEmpty) ...[
                      const SectionTitle(title: "RESTAURANTES"),
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

  Widget _buildRestaurantWithPlates(Plate plate, List<Restaurant> restaurants) {
    final restaurant = restaurants.firstWhere(
      (res) => res.restaurantId == plate.cartId,
      orElse: () => Restaurant(
          restaurantId: 0,
          name: "Desconocido",
          location: "N/A",
          contactNumber: "N/A",
          horario: "N/A",
          idDueno: "N/A",
          createdAt: DateTime.now()),
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
