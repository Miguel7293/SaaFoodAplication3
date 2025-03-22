import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import '../../../data/services/plate_repository.dart';
import '../../../data/services/restaurant_repository.dart';
import '../../widgets/plates_list_view.dart';
import 'plus_dishes.dart';
import '../../../data/models/user.dart';
import '../../../data/services/user_repository.dart';
import '../../../data/models/restaurant.dart'; 

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  final PlateRepository plateRepository = PlateRepository();
  final RestaurantRepository restaurantRepository = RestaurantRepository();

  Future<User> _ownerFuture = UserRepository().getAuthenticatedUser();
  Future<List<Restaurant>>? _restaurantsFuture;  String? userUid;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final user = await _ownerFuture;
      setState(() {
        userUid = user.userUid;
      });

      if (userUid != null) {
        final restaurants = await restaurantRepository.getRestaurantsByAuthenticatedUser(userUid!);
        setState(() {
          _restaurantsFuture = Future.value(restaurants);
        });
      }
    } catch (e) {
      debugPrint("❌ Error al obtener usuario o restaurantes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<Restaurant>>(
          future: _restaurantsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Cargando...'); // Muestra un texto mientras carga
            }
            if (snapshot.hasError) {
              return const Text('Error al cargar el nombre del restaurante');
            }
            final restaurantName = snapshot.data!.first.name;
            return Text(restaurantName); 
          },
        ),
      ),
      body: FutureBuilder(
        future: plateRepository.getAllPlates(), // Obtener platos desde Supabase
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final myplates = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Carta Actual',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Desayuno',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                PlatesListView(plates: myplates),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Cartas Desactivadas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildCategorySection("Almuerzo", myplates, context),
                _buildCategorySection("Cena", myplates, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Plate> plates, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddDishesScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 10),
          PlatesListView(plates: plates),
        ],
      ),
    );
  }
}