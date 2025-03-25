import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:flutter_application_example/presentation/theme/styles.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar provider
import '../../../data/services/user_repository.dart';
import '../../../data/models/user.dart';
import '../../providers/auth_provider.dart'; // Asegúrate de importar el AuthProvider

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = UserRepository().getAuthenticatedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppStyles.appBar("Perfil del Usuario"),
      body: FutureBuilder<User>(
        future: _userFuture,
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagen de perfil
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.profileImage.isNotEmpty
                      ? NetworkImage(user.profileImage)
                      : const AssetImage("assets/images/default_avatar.png") as ImageProvider,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 20),

                // Nombre de usuario
                Text(
                  user.username,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),

                // Correo electrónico
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),

                // Tipo de usuario
                _buildProfileInfo("Tipo de Usuario", user.typeUser),

                // Fecha de creacion
                _buildProfileInfo("Cuenta creada el", "${user.createdAt.toLocal()}".split(' ')[0]),

                const SizedBox(height: 20),

                // Botón de Cerrar Sesion
                ElevatedButton.icon(
                  onPressed: () async {
                    // Llamamos al método logout
                    await Provider.of<AuthProvider>(context, listen: false).logout();

                    // Después de cerrar sesión, redirigimos a la pantalla de login
                    Navigator.pushReplacementNamed(context, '/login'); // Asegúrate de tener '/login' configurado en tu MaterialApp
                  },
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text("Cerrar Sesión"),
                  style: AppStyles.buttonStyle(AppColors.red),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Widget para mostrar información con un titulo y valor
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
