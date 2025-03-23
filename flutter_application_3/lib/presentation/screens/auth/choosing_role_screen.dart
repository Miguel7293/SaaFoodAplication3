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
    backgroundColor: AppColors.appBackground,
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo con efecto de elevación
          Expanded(
            child: Center( // Centra el logo vertical y horizontalmente
              child: SvgPicture.asset(
                'assets/images/logo_app.svg',
                height: 210,  // Tamaño aumentado
                semanticsLabel: 'App Logo',
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Contenedor de botones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Botón Cliente
                _buildRoleButton(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  title: 'Soy Cliente',
                  subtitle: 'Buscar y disfrutar experiencias gastronómicas',
                  onPressed: () => _updateUserType(context, 'customer'),
                ),
                const SizedBox(height: 20),
                
                // Botón Dueño
                _buildRoleButton(
                  context: context,
                  icon: Icons.storefront_outlined,
                  title: 'Soy Dueño de Negocio',
                  subtitle: 'Gestionar y promocionar mi establecimiento',
                  onPressed: () => _updateUserType(context, 'NotSpecified'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildRoleButton({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.googleButtonBackground,
      foregroundColor: AppColors.primaryTextColor,
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: AppColors.googleButtonBorder.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),
    onPressed: onPressed,
    child: Row(
      children: [
        Icon(icon, size: 28, color: AppColors.primaryColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey,
        ),
      ],
    ),
  );
}
}

