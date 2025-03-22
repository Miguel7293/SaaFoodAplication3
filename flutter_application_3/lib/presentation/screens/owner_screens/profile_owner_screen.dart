import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/services/user_repository.dart';
import '../../../data/models/user.dart';
import '../../../data/services/restaurant_repository.dart'; 
import '../../../data/models/restaurant.dart'; 
import '../../../presentation/providers/auth_provider.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  late RestaurantRepository _restaurantRepo;
  late UserRepository _userRepo;
  late String? _userId;

  final double coverHeight = 280; 
  final double profileHeight = 144; 

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
  }

  void _initializeRepositories() {
    _restaurantRepo = Provider.of<RestaurantRepository>(context, listen: false);
    _userRepo = Provider.of<UserRepository>(context, listen: false);
    _userId = Provider.of<AuthProvider>(context, listen: false).userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User>(
        future: _userRepo.getAuthenticatedUser(), // Llamada directa al repositorio
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("No se encontraron datos del usuario"));
          }

          final user = snapshot.data!;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              buildTop(user),
              buildContent(user),
            ],
          );
        },
      ),
    );
  }

  Widget buildCoverImage(User user) => FutureBuilder<List<Restaurant>>(
    future: _restaurantRepo.getRestaurantsByAuthenticatedUser(_userId!), // Llamada directa al repositorio
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator()); 
      }
      if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      }

      final restaurants = snapshot.data;
      final imageUrl = restaurants?.isNotEmpty == true
          ? restaurants!.first.imageOfLocal 
          : user.profileImage; 

      return Container(
        color: Colors.grey,
        child: Image.network(
          imageUrl?.isNotEmpty == true
              ? imageUrl!
              : 'https://wallhaven.cc/w/rdmo8m', 
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );
    },
  );

  Widget buildProfileImage(User user) => CircleAvatar(
    radius: profileHeight / 2,
    backgroundColor: Colors.grey.shade800,
    backgroundImage: NetworkImage(
      user.profileImage.isNotEmpty
          ? user.profileImage
          : 'https://wallhaven.cc/w/rdmo8m', 
    ),
  );

  Widget buildTop(User user) {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(user),
        ),
        Positioned(
          top: top,
          child: buildProfileImage(user),
        ),
      ],
    );
  }

  Widget buildContent(User user) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          user.username,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          user.email,
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
        const SizedBox(height: 20),
        _buildProfileInfo("Tipo de Usuario", user.typeUser),
        _buildProfileInfo("Cuenta creada el", "${user.createdAt.toLocal()}".split(' ')[0]),

        _buildRestaurantInfo(
          title: "Nombre del Restaurante",
          value: (restaurant) => restaurant.name,
        ),
        _buildRestaurantInfo(
          title: "Número de Celular",
          value: (restaurant) => restaurant.contactNumber,
        ),

        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            // Lógica para cerrar sesión
          },
          icon: const Icon(Icons.exit_to_app),
          label: const Text("Cerrar Sesión"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    ),
  );

  Widget _buildProfileInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfo({
    required String title,
    required String Function(Restaurant) value,
  }) {
    return FutureBuilder<List<Restaurant>>(
      future: _restaurantRepo.getRestaurantsByAuthenticatedUser(_userId!), // Llamada directa al repositorio
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildProfileInfo(title, "Cargando...");
        }
        if (snapshot.hasError) {
          return _buildProfileInfo(title, "Error al cargar");
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildProfileInfo(title, "No disponible");
        }

        final restaurantValue = value(snapshot.data!.first);
        return _buildProfileInfo(title, restaurantValue);
      },
    );
  }
}