import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../presentation/providers/auth_provider.dart';
import 'package:flutter_application_example/data/models/user.dart' as app_model;
import 'package:flutter_svg/flutter_svg.dart'; // Este import es crucial

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userRepo = Provider.of<UserRepository>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);

    try {
    // 1. Autenticación con Google
    await auth.loginWithGoogle();
    
    // 2. Espera progresiva con timeout
    const maxRetries = 5;
    const retryDelay = Duration(milliseconds: 500);
    String? uid;
    
    for (int i = 0; i < maxRetries; i++) {
      uid = auth.userId;
      if (uid != null) break;
      await Future.delayed(retryDelay);
    }

    if (uid == null) throw Exception('No se pudo obtener el ID de usuario después de ${maxRetries * retryDelay.inMilliseconds}ms');

    // 3. Verificar/crear usuario
    app_model.User user;
      
      try {
        user = await userRepo.getUserById(uid);
      } catch (e) {
        // Crear nuevo usuario si no existe
        final googleUser = auth.currentUser;
        user = await userRepo.createUser(
          userUid: uid,
          email: googleUser?.email ?? '',
          username: googleUser?.userMetadata?['name'] ?? 'Nuevo Usuario',
          typeUser: 'customer', // Valor por defecto
          profileImage: googleUser?.userMetadata?['avatar_url'] ?? '',
        );
      }

      // 4. Navegación basada en tipo de usuario
      _redirectUser(context, user.typeUser);

    } on AuthException catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text('Error de autenticación: ${e.message}'),
      ));
    } on PostgrestException catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text('Error de base de datos: ${e.message}'),
      ));
    } catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text('Error inesperado: ${e.toString()}'),
      ));
    }
  }

  void _redirectUser(BuildContext context, String userType) {
    final routes = {
      'NotSpecified': '/choosing-role',
      'isWaiting': '/waiting-approval',
      'customer': '/customer',
      'owner': '/owner'
    };
    Navigator.pushReplacementNamed(context, routes[userType]!);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.appBackground,
    body: SafeArea(
      child: Column(
        children: [
          // Espacio flexible para empujar el logo al centro
          Expanded(
            child: Center( // Centra el logo vertical y horizontalmente
              child: SvgPicture.asset(
                'assets/images/logo_app.svg',  // Ruta CORRECTA (sin 'lib/')
                height: 210,  // Tamaño aumentado
                semanticsLabel: 'App Logo',
              ),
            ),
          ),
          // Botón de Google en la parte inferior
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.googleButtonText,
                backgroundColor: AppColors.googleButtonBackground,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),  // Padding vertical reducido
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),  // Borde redondeado
                  side: BorderSide(color: AppColors.googleButtonBorder),
                ),
              ),
              onPressed: () => _handleGoogleLogin(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/google_icon.svg',  // Ruta CORRECTA
                    height: 24,  // Tamaño de icono reducido
                  ),
                  const SizedBox(width: 12),  // Espaciado reducido
                  const Text(
                    'Ingresar con Google',
                    style: TextStyle(
                      fontSize: 16,  // Texto más pequeño
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Enlace "¿Primera vez? Crea una cuenta"
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),  // Espaciado inferior
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: Text(
                '¿Primera vez? Crea una cuenta',
                style: TextStyle(
                  color: AppColors.secondaryTextColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}