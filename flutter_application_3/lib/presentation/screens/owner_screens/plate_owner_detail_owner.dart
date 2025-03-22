// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/presentation/theme/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_example/presentation/providers/carta_notifier.dart';

class PlateDetailOwnerScreen extends StatefulWidget {
  final int plateId; 

  const PlateDetailOwnerScreen({super.key, required this.plateId});

  @override
  State<PlateDetailOwnerScreen> createState() => _PlateDetailOwnerScreenState();
}

class _PlateDetailOwnerScreenState extends State<PlateDetailOwnerScreen> {
  late Future<Plate> _plateFuture; 
  final PlateRepository _plateRepository = PlateRepository();
  bool _isAvailable = false; 

  @override
  void initState() {
    super.initState();
    _loadPlate(); 
  }

  Future<void> _loadPlate() async {
    _plateFuture = _plateRepository.getPlateById(widget.plateId);
    final plate = await _plateFuture;
    setState(() {
      _isAvailable = plate.available; 
    });
  }

  Future<void> _toggleAvailability(bool value) async {
    final plate = await _plateFuture;
    final updatedPlate = plate.copyWith(available: value);

    try {
      await _plateRepository.updatePlate(updatedPlate);

      final cartaProvider = Provider.of<CartaProvider>(context, listen: false);
      cartaProvider.updatePlateInCarta(updatedPlate);

      setState(() {
        _isAvailable = value; // Actualizar el estado local
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Disponibilidad actualizada correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar disponibilidad: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Plato')),
      body: FutureBuilder<Plate>(
        future: _plateFuture, // Usar Future en lugar de Stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No se encontró el plato.'));
          }

          final plate = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppStyles.detailImage(plate.image),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  plate.name,
                  style: AppStyles.tittleTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  plate.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Precio: S/. ${plate.price.toStringAsFixed(2)}",
                  style: AppStyles.secondaryTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      "Disponibilidad:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Switch(
                      value: _isAvailable, // Usar el estado local
                      onChanged: (value) => _toggleAvailability(value),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}