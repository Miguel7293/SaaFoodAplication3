import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/carta.dart';

class EditMenuOwnerScreen extends StatelessWidget {
  final Carta carta; 

  const EditMenuOwnerScreen({super.key, required this.carta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar ${carta.type}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nombre: ${carta.type}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Descripción: ${carta.description}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "Estado: ${carta.state ? 'Activa' : 'Desactivada'}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "ID de la carta: ${carta.cartaId}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}