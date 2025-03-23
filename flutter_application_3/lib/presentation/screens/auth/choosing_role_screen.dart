import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/auth_provider.dart';

class ChoosingRoleScreen extends StatelessWidget {
  const ChoosingRoleScreen({super.key});

  Future<void> _updateUserType(BuildContext context, String type) async {
    final userRepo = Provider.of<UserRepository>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      await userRepo.updateUserType(auth.userId!, type);
      _redirectBasedOnType(context, type);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}'))
      );
    }
  }

  void _redirectBasedOnType(BuildContext context, String type) {
    if (type == 'customer') {
      Navigator.pushReplacementNamed(context, '/customer');
    } else {
      Navigator.pushReplacementNamed(context, '/owner-survey');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.appBackground,  // Color de fondo
    body: SafeArea(
      child: Center(  // Centra todo el contenido
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centra verticalmente
          children: [
            // Logo centrado
            SvgPicture.asset(
              'lib/assets/images/logo_app.svg',  // Ruta del logo
              height: 210,  // Tamaño del logo
              semanticsLabel: 'App Logo',
            ),
            const SizedBox(height: 40),  // Espaciado entre el logo y los botones
            // Botones centrados
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Botón "Soy Cliente"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,  // Texto en negro
                      backgroundColor: AppColors.googleButtonBackground,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),  // Borde redondeado
                        side: BorderSide(color: AppColors.googleButtonBorder),
                      ),
                    ),
                    onPressed: () => _updateUserType(context, 'customer'),
                    child: const Text(
                      'Soy Cliente',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),  // Espaciado entre botones
                  // Botón "Soy Dueño de Negocio"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,  // Texto en negro
                      backgroundColor: AppColors.googleButtonBackground,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),  // Borde redondeado
                        side: BorderSide(color: AppColors.googleButtonBorder),
                      ),
                    ),
                    onPressed: () => _updateUserType(context, 'NotSpecified'),
                    child: const Text(
                      'Soy Dueño de Negocio',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}