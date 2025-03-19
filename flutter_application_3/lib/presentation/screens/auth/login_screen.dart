import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/user.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Screen'),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Iniciar sesión con Google
                  await Provider.of<AuthProvider>(context, listen: false).loginWithGoogle();

                  // Obtener el repositorio de usuario
                  final userRepo = Provider.of<UserRepository>(context, listen: false);

                  // Obtener información del usuario autenticado
                  final User user = await userRepo.getAuthenticatedUser();

                  // Debug para verificar el usuario
                  debugPrint("Usuario autenticado: ${user.userUid}, tipo: ${user.typeUser}");

                  // Redirigir según el typeUser
                  if (user.typeUser == 'customer') {
                    Navigator.pushReplacementNamed(context, '/customer');
                  } else if (user.typeUser == 'owner') {
                    Navigator.pushReplacementNamed(context, '/owner');
                  } else {
                    throw Exception('Tipo de usuario desconocido');
                  }
                } catch (e) {
                  debugPrint("Error en login: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Iniciar con Google'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}
