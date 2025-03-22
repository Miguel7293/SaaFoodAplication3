import 'package:flutter/material.dart';
import '../../../data/services/user_repository.dart';
import '../../../data/models/user.dart';
import '../../../data/services/restaurant_repository.dart'; 
import '../../../data/models/restaurant.dart'; 

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  final double coverHeight = 280; 
  final double profileHeight = 144; 

  Future<User> _ownerFuture = UserRepository().getAuthenticatedUser();
  Future<List<Restaurant>>? _restaurantsFuture; 
  String? userUid; 

  @override
  void initState() {
    super.initState();
    _loadUserAndRestaurants(); 
  }

  void _loadUserAndRestaurants() async {
    try {
      // Obtener el usuario autenticado
      final user = await _ownerFuture;
      setState(() {
        userUid = user.userUid; 
      });

      if (userUid != null) {
        final restaurants = await RestaurantRepository().getRestaurantsByAuthenticatedUser(userUid!);
        setState(() {
          _restaurantsFuture = Future.value(restaurants);
        });

        if (restaurants.isNotEmpty) {
          debugPrint("✅ Restaurantes cargados correctamente:");
          for (final restaurant in restaurants) {
            debugPrint("Nombre: ${restaurant.name}, ID: ${restaurant.restaurantId}");
          }
        } else {
          debugPrint("⚠️ No se encontraron restaurantes para el userUid: $userUid");
        }
      }
    } catch (e) {
      debugPrint("❌ Error al obtener usuario o restaurantes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User>(
        future: _ownerFuture,
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
    future: _restaurantsFuture,
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
              : 'https://w.wallhaven.cc/full/o3/wallhaven-o3715l.png', 
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
          : 'https://w.wallhaven.cc/full/1p/wallhaven-1pk8r9.jpg', 
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

  /// Construye el contenido de la información del usuario
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
        // Correo electrónico
        Text(
          user.email,
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
        const SizedBox(height: 20),
        // Tipo de usuario
        _buildProfileInfo("Tipo de Usuario", user.typeUser),
        // Fecha de creación
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
        // Botón de Cerrar Sesión
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
    future: _restaurantsFuture,
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

      // Obtener el valor del restaurante usando la función `value`
      final restaurantValue = value(snapshot.data!.first);
      return _buildProfileInfo(title, restaurantValue);
    },
  );
}
}
