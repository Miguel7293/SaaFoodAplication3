import 'package:flutter/material.dart';
import '../../../data/services/user_repository.dart';
import '../../../data/models/user.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  final double coverHeight = 280; // Altura de la imagen de portada
  final double profileHeight = 144; // Altura del círculo de perfil

  Future<User> _ownerFuture = UserRepository().getAuthenticatedUser();

  @override
  void initState() {
    super.initState();
    _ownerFuture = UserRepository().getAuthenticatedUser();
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
              // Sección superior con la imagen de portada y perfil
              buildTop(user),
              // Contenido de la información del usuario
              buildContent(user),
            ],
          );
        },
      ),
    );
  }

  /// Construye la imagen de portada
  Widget buildCoverImage(User user) => Container(
    color: Colors.grey,
    child: Image.network(
      user.profileImage.isNotEmpty
          ? user.profileImage
          : 'https://w.wallhaven.cc/full/o3/wallhaven-o3715l.png', // Imagen por defecto
      width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    ),
  );

  /// Construye la imagen de perfil
  Widget buildProfileImage(User user) => CircleAvatar(
    radius: profileHeight / 2,
    backgroundColor: Colors.grey.shade800,
    backgroundImage: NetworkImage(
      user.profileImage.isNotEmpty
          ? user.profileImage
          : 'https://w.wallhaven.cc/full/1p/wallhaven-1pk8r9.jpg', // Imagen por defecto
    ),
  );

  /// Construye la sección superior (portada + perfil)
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
        SizedBox(height: profileHeight / 2), // Espacio para el perfil
        // Nombre de usuario
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

  /// Widget para mostrar información con un título y valor
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
}