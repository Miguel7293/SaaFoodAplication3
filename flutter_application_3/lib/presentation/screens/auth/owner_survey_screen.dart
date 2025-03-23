import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/auth_provider.dart';

class OwnerSurveyScreen extends StatefulWidget {
  const OwnerSurveyScreen({super.key});

  @override
  State<OwnerSurveyScreen> createState() => _OwnerSurveyScreenState();
}

class _OwnerSurveyScreenState extends State<OwnerSurveyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessInfo = TextEditingController();

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final userRepo = Provider.of<UserRepository>(context, listen: false);
      final auth = Provider.of<AuthProvider>(context, listen: false);
      
      try {
        // 1. Enviar formulario al backend
        
        // 2. Actualizar estado del usuario
        await userRepo.updateUserType(auth.userId!, 'isWaiting');
        
        // 3. Redirigir
        Navigator.pushReplacementNamed(context, '/waiting-approval');
      } catch (e) {
        // Manejar error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitud de Dueño')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _businessInfo,
                decoration: const InputDecoration(
                  labelText: 'Información del Negocio'
                ),
                validator: (value) => value!.isEmpty 
                    ? 'Campo obligatorio' 
                    : null,
              ),
              ElevatedButton(
                onPressed: _submitRequest,
                child: const Text('Enviar Solicitud'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}