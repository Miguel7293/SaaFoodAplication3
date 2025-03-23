import 'package:flutter/material.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text('Solicitud en revisión'),
            TextButton(
              onPressed: () => _checkStatus(context),
              child: const Text('Verificar Estado'),
            ),
          ],
        ),
      ),
    );
  }
}