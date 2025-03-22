import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_example/data/services/carta_repository.dart';
import 'package:flutter_application_example/data/models/carta.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/services/restaurant_repository.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:flutter_application_example/presentation/providers/auth_provider.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import '../../../presentation/screens/owner_screens/plus_dishes.dart'; 
import '../../widgets/plates_list_view.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  late CartaRepository _cartaRepo;
  late PlateRepository _plateRepo;
  late RestaurantRepository _restaurantRepo;
  late UserRepository _userRepo;
  late String? _userId;
  List<Carta> _cartas = [];
  int? _restaurantId;
  Map<int, List<Plate>> _platesByCarta = {}; // Mapa para almacenar platos por carta

  // Listas separadas para cartas activas e inactivas
  List<Carta> _cartasActivas = [];
  List<Carta> _cartasInactivas = [];

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Aquí puedes realizar acciones que requieran un contexto válido
  }

  void _initializeRepositories() {
    _plateRepo = Provider.of<PlateRepository>(context, listen: false);
    _cartaRepo = Provider.of<CartaRepository>(context, listen: false);
    _restaurantRepo = Provider.of<RestaurantRepository>(context, listen: false);
    _userRepo = Provider.of<UserRepository>(context, listen: false);
    _userId = Provider.of<AuthProvider>(context, listen: false).userId;
  }

  Future<void> _loadData() async {
    try {
      if (_userId == null) {
        throw Exception("El ID del usuario no es válido: $_userId");
      }

      // Obtener todos los restaurantes asociados al usuario
      final restaurants = await _restaurantRepo.getRestaurantsByAuthenticatedUser(_userId!);

      if (restaurants.isEmpty) {
        throw Exception("El usuario no tiene restaurantes asociados.");
      }

      // Obtener el ID del primer restaurante asociado al usuario
      final restaurantId = restaurants.first.restaurantId;

      // Obtener las cartas del restaurante
      final cartas = await _cartaRepo.getCartasByRestaurant(restaurantId);

      // Obtener los platos para cada carta
      final platesByCarta = <int, List<Plate>>{};
      for (final carta in cartas) {
        final plates = await _plateRepo.getPlatesByCartaId(carta.cartaId!); 
        platesByCarta[carta.cartaId!] = plates;
      }

      // Filtrar cartas activas e inactivas
      final cartasActivas = cartas.where((carta) => carta.state == true).toList();
      final cartasInactivas = cartas.where((carta) => carta.state == false).toList();

      // Actualizar el estado con los datos obtenidos
      setState(() {
        _restaurantId = restaurantId;
        _cartas = cartas;
        _platesByCarta = platesByCarta;
        _cartasActivas = cartasActivas;
        _cartasInactivas = cartasInactivas;
      });

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
      body: _cartas.isEmpty
          ? const Center(child: Text("No hay cartas disponibles."))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de Cartas Activas
                  if (_cartasActivas.isNotEmpty)
                    _buildCartaSection("Cartas Activas", _cartasActivas),

                  // Sección de Cartas Inactivas
                  if (_cartasInactivas.isNotEmpty)
                    _buildCartaSection("Cartas Inactivas", _cartasInactivas),
                ],
              ),
            ),
    );
  }

  Widget _buildCartaSection(String title, List<Carta> cartas) {
    return Padding(
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
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartas.length,
            itemBuilder: (context, index) {
              final carta = cartas[index];
              final plates = _platesByCarta[carta.cartaId] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carta.type ?? 'Sin nombre',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildCategorySection("Platos", plates, context),
                ],
              );
            },
          ),
        ],
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