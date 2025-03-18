import 'package:flutter/material.dart';

class PlusDishesScreen extends StatelessWidget {
  const PlusDishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Platos'),
      ),
      body: const Center(
        child: Text('Aquí puedes agregar nuevos platos.'),
      ),
    );
  }
}