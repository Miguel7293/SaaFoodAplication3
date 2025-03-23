import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/carta.dart';
import 'package:flutter_application_example/data/services/carta_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_example/presentation/providers/carta_notifier.dart';

class EditMenuOwnerScreen extends StatefulWidget {
  final Carta carta;

  const EditMenuOwnerScreen({super.key, required this.carta});

  @override
  State<EditMenuOwnerScreen> createState() => _EditMenuOwnerScreenState();
}

class _EditMenuOwnerScreenState extends State<EditMenuOwnerScreen> {
  late TextEditingController _typeController;
  late TextEditingController _descriptionController;
  late bool _state;
  final CartaRepository _cartaRepository = CartaRepository();
  bool _hasChanges = false; // Variable para rastrear cambios

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.carta.type);
    _descriptionController = TextEditingController(text: widget.carta.description);
    _state = widget.carta.state;
  }

  @override
  void dispose() {
    _typeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Método para verificar cambios
  void _checkForChanges() {
    final typeChanged = _typeController.text != widget.carta.type;
    final descriptionChanged = _descriptionController.text != widget.carta.description;
    final stateChanged = _state != widget.carta.state;

    setState(() {
      _hasChanges = typeChanged || descriptionChanged || stateChanged;
    });
  }

  Future<void> _updateCarta() async {
    final updatedCarta = Carta(
      cartaId: widget.carta.cartaId,
      type: _typeController.text,
      description: _descriptionController.text,
      restCart: widget.carta.restCart,
      updatedAt: DateTime.now(), // Actualizar la fecha
      state: _state,
    );

    try {
      final success = await _cartaRepository.updateCarta(updatedCarta);

      if (success) {
        // Notificar al CartaProvider sobre el cambio
        final cartaProvider = Provider.of<CartaProvider>(context, listen: false);
        cartaProvider.updateCarta(updatedCarta);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Carta actualizada correctamente')),
          );

          // Regresar a la pantalla anterior
          Navigator.pop(context, true); // Indicar que se actualizó la carta
        }
      } else {
        throw Exception('No se pudo actualizar la carta');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar la carta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar ${widget.carta.type}"),
        // Eliminamos la sección de actions para quitar el ícono de guardar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nombre:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(
                  hintText: 'Ingrese el nombre de la carta',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el nombre de la carta';
                  }
                  return null;
                },
                onChanged: (value) => _checkForChanges(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Descripción:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ingrese la descripción de la carta',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la descripción de la carta';
                  }
                  return null;
                },
                onChanged: (value) => _checkForChanges(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Estado:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Activa'),
                value: _state,
                onChanged: (value) {
                  setState(() {
                    _state = value;
                    _checkForChanges();
                  });
                },
                tileColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(height: 24),

              // Botón de guardar (solo aparece si hay cambios)
              if (_hasChanges)
                Center(
                  child: ElevatedButton(
                    onPressed: _updateCarta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Guardar Cambios',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}