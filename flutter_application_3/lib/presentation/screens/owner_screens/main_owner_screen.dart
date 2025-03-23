import 'package:flutter/material.dart';
import 'package:flutter_application_example/presentation/widgets/plates_list_view_owner.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_example/data/services/carta_repository.dart';
import 'package:flutter_application_example/data/models/carta.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/services/restaurant_repository.dart';
import 'package:flutter_application_example/presentation/providers/auth_provider.dart';
import 'package:flutter_application_example/presentation/providers/carta_notifier.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import '../../../presentation/screens/owner_screens/plus_dishes.dart'; 
import '../../../presentation/screens/owner_screens/edit_menu_owner.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  late CartaRepository _cartaRepo;
  late PlateRepository _plateRepo;
  late RestaurantRepository _restaurantRepo;
  late String? _userId;
  late CartaProvider _cartaProvider;

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _initializeRepositories() {
    _plateRepo = Provider.of<PlateRepository>(context, listen: false);
    _cartaRepo = Provider.of<CartaRepository>(context, listen: false);
    _restaurantRepo = Provider.of<RestaurantRepository>(context, listen: false);
    _cartaProvider = Provider.of<CartaProvider>(context, listen: false);
    _userId = Provider.of<AuthProvider>(context, listen: false).userId;
  }

  Future<void> _loadData() async {
    try {
      if (_userId == null) {
        throw Exception("El ID del usuario no es válido: $_userId");
      }
      final restaurants = await _restaurantRepo.getRestaurantsByAuthenticatedUser(_userId!);

      if (restaurants.isEmpty) {
        throw Exception("El usuario no tiene restaurantes asociados.");
      }

      final restaurantId = restaurants.first.restaurantId;
      final cartas = await _cartaRepo.getCartasByRestaurant(restaurantId);
      final platesByCarta = <int, List<Plate>>{};
      for (final carta in cartas) {
        final plates = await _plateRepo.getPlatesByCartaId(carta.cartaId); 
        platesByCarta[carta.cartaId] = plates;
      }

      _cartaProvider.setCartas(cartas);
      _cartaProvider.setPlatesByCarta(platesByCarta);

      debugPrint("Datos cargados correctamente");
    } catch (e) {
      debugPrint("❌ Error al cargar datos: $e");
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error al cargar datos: $e"),
              backgroundColor: Colors.red,
            ),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<Restaurant>>(
          future: _restaurantRepo.getRestaurantsByAuthenticatedUser(_userId!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Cargando...');
            }
            if (snapshot.hasError) {
              return const Text('Error al cargar el nombre del restaurante');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Sin restaurante');
            }
            final restaurantName = snapshot.data!.first.name;
            return Text(restaurantName);
          },
        ),
      ),
      body: Consumer<CartaProvider>(
        builder: (context, cartaProvider, child) {
          final cartas = cartaProvider.cartas;
          final platesByCarta = cartaProvider.platesByCarta;
          final cartasActivas = cartas.where((carta) => carta.state == true).toList();
          final cartasInactivas = cartas.where((carta) => carta.state == false).toList();

          return cartas.isEmpty
              ? const Center(child: Text("No hay cartas disponibles."))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (cartasActivas.isNotEmpty)
                        _buildCartaSection("Cartas Activas", cartasActivas, platesByCarta),

                      if (cartasInactivas.isNotEmpty)
                        _buildCartaSection("Cartas Desactivadas", cartasInactivas, platesByCarta),
                    ],
                  ),
                );
        },
      ),
    );
  }

Widget _buildCartaSection(String title, List<Carta> cartas, Map<int, List<Plate>> platesByCarta) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Card(
      elevation: 4, // Elevación para dar sombra
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartas.length,
              itemBuilder: (context, index) {
                final carta = cartas[index];
                final plates = platesByCarta[carta.cartaId] ?? [];

                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditMenuOwnerScreen(carta: carta),
                      ),
                    );

                    if (result == true) {
                      _loadData();
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          carta.type,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildCategorySection("Platos", plates, carta, context),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildCategorySection(String title, List<Plate> plates, Carta carta, BuildContext context) {
    final sortedPlates = List<Plate>.from(plates)
      ..sort((a, b) => b.available ? 1 : -1);

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
              if (!carta.state)
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDishesScreen(cartaId: carta.cartaId),
                      ),
                    );

                    if (result == true) {
                      _loadData();
                    }
                  },
                  icon: const Icon(Icons.add, size: 30),
                ),
            ],
          ),
          const SizedBox(height: 10),
          PlatesListViewOwner(plates: sortedPlates), 
        ],
      ),
    );
  }
}