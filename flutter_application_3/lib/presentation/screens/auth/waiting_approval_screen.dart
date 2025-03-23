import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/auth_provider.dart';

class WaitingApprovalScreen extends StatelessWidget {
  const WaitingApprovalScreen({super.key});



  void _checkStatus(BuildContext context) async {
    final userRepo = Provider.of<UserRepository>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      final user = await userRepo.getUserById(auth.userId!);
      if (user.typeUser == 'owner') {
        Navigator.pushReplacementNamed(context, '/owner');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aún en revisión'))
        );
      }
    } catch (e) {
      // Manejar error
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.appBackground,
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicador de progreso con contraste
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 0, 0), // Usar color primario
                strokeWidth: 5,
                strokeCap: StrokeCap.round,
              ),
            ),
            const SizedBox(height: 40),
            
            // Texto principal destacado
            const Text(
              'Solicitud en revisión',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor, // Color primario
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 15),
            
            // Texto secundario con mejor legibilidad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                'Estamos validando tu información. Te notificaremos cuando finalice el proceso.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 88, 88, 88), // Gris oscuro
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 35),
            
            // Botón con diseño moderno
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                elevation: 2,
              ),
              icon: const Icon(Icons.refresh_rounded, size: 22),
              label: const Text(
                'Actualizar estado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => _checkStatus(context),
            ),
          ],
        ),
      ),
    ),
  );
}
}