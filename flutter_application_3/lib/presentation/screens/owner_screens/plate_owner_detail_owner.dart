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
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _loadPlate();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _loadPlate() async {
    _plateFuture = _plateRepository.getPlateById(widget.plateId);
    final plate = await _plateFuture;
    setState(() {
      _isAvailable = plate.available;
      _nameController.text = plate.name;
      _descriptionController.text = plate.description;
      _priceController.text = plate.price.toStringAsFixed(2);
    });
  }

  void _checkForChanges() {
    final plate = _plateFuture.then((plate) {
      final nameChanged = _nameController.text != plate.name;
      final descriptionChanged = _descriptionController.text != plate.description;
      final priceChanged = double.parse(_priceController.text) != plate.price;
      final availabilityChanged = _isAvailable != plate.available;

      setState(() {
        _hasChanges = nameChanged || descriptionChanged || priceChanged || availabilityChanged;
      });
    });
  }

  Future<void> _toggleAvailability(bool value) async {
    setState(() {
      _isAvailable = value;
      _checkForChanges();
    });
  }

  Future<void> _saveChanges() async {
    try {
      final plate = await _plateFuture;
      final updatedPlate = plate.copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        available: _isAvailable,
      );

      final updatedPlateResponse = await _plateRepository.updatePlate(updatedPlate);

      if (updatedPlateResponse != null) {
        final cartaProvider = Provider.of<CartaProvider>(context, listen: false);
        cartaProvider.updatePlateInCarta(updatedPlateResponse);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cambios guardados correctamente')),
          );

          // Regresar a la pantalla anterior
          Navigator.pop(context, true); // Indicar que se guardaron cambios
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar cambios: $e')),
        );
      }
    }
  }

  Future<void> _deletePlate() async {
    try {
      final plate = await _plateFuture;

      // Eliminar el plato de la base de datos
      final success = await _plateRepository.deletePlate(plate.plateId!);

      if (success) {
        // Notificar al CartaProvider para eliminar el plato de la lista
        final cartaProvider = Provider.of<CartaProvider>(context, listen: false);
        cartaProvider.deletePlateFromCarta(plate.plateId!);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Plato eliminado correctamente')),
          );

          // Regresar a la pantalla anterior
          Navigator.pop(context, true); // Indicar que se eliminó un plato
        }
      } else {
        throw Exception('No se pudo eliminar el plato');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el plato: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Plato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar Plato'),
                  content: const Text('¿Estás seguro de que deseas eliminar este plato?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _deletePlate();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Plate>(
        future: _plateFuture,
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
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen del plato
                    AppStyles.detailImage(plate.image),
                    const SizedBox(height: 16),

                    // Nombre del plato
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nombre:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Ingrese el nombre del plato',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => _checkForChanges(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Descripción del plato
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Descripción:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Ingrese la descripción del plato',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => _checkForChanges(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Precio del plato
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Precio:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Ingrese el precio del plato',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) => _checkForChanges(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Disponibilidad del plato
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Disponibilidad:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SwitchListTile(
                              title: const Text('Disponible'),
                              value: _isAvailable,
                              onChanged: (value) => _toggleAvailability(value),
                              tileColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 80), // Espacio para el botón flotante
                  ],
                ),
              ),

              // Botón de guardar flotante
              if (_hasChanges)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Guardar Cambios',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}