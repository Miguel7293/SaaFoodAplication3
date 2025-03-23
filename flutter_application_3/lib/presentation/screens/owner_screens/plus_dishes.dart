import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/presentation/providers/carta_notifier.dart';

class AddDishesScreen extends StatefulWidget {
  final int cartaId;

  const AddDishesScreen({super.key, required this.cartaId});

  @override
  State<AddDishesScreen> createState() => _AddDishesScreenState();
}

class _AddDishesScreenState extends State<AddDishesScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  String? selectedCategory;
  bool _available = true;
  String _image = 'https://w.wallhaven.cc/full/72/wallhaven-72zyzv.png';
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    final nameChanged = _nameController.text.isNotEmpty;
    final descriptionChanged = _descriptionController.text.isNotEmpty;
    final priceChanged = _priceController.text.isNotEmpty;
    final categoryChanged = selectedCategory != null;

    setState(() {
      _hasChanges = nameChanged || descriptionChanged || priceChanged || categoryChanged;
    });
  }

  Future<void> _savePlate(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final plate = Plate(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        available: _available,
        image: _image,
        cartId: widget.cartaId,
        category: selectedCategory ?? 'Sin categoría',
      );

      try {
        final plateRepo = Provider.of<PlateRepository>(context, listen: false);
        await plateRepo.addPlate(plate);

        final cartaProvider = Provider.of<CartaProvider>(context, listen: false);
        cartaProvider.addPlateToCarta(widget.cartaId, plate);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Plato guardado correctamente"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al guardar el plato: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Plato'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de nombre
              _buildSectionTitle('Nombre del Plato'),
              _buildTextField(
                controller: _nameController,
                hintText: 'Ingrese el nombre del plato',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el nombre del plato';
                  }
                  return null;
                },
                onChanged: (value) => _checkForChanges(),
              ),
              const SizedBox(height: 20),

              // Campo de descripción
              _buildSectionTitle('Descripción del Plato'),
              _buildTextField(
                controller: _descriptionController,
                hintText: 'Ingrese la descripción del plato',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la descripción del plato';
                  }
                  return null;
                },
                onChanged: (value) => _checkForChanges(),
              ),
              const SizedBox(height: 20),

              // Campo de precio
              _buildSectionTitle('Precio del Plato'),
              _buildTextField(
                controller: _priceController,
                hintText: 'Ingrese el precio del plato',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money, color: Colors.black54),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el precio del plato';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, ingrese un precio válido';
                  }
                  return null;
                },
                onChanged: (value) => _checkForChanges(),
              ),
              const SizedBox(height: 20),

              // Campo de categoría
              _buildSectionTitle('Categoría del Plato'),
              _buildCategoryDropdown(),
              const SizedBox(height: 20),

              // Disponibilidad e Imagen Referencial en la misma fila
              _buildSectionTitle('Disponibilidad e Imagen'),
              _buildAvailabilityAndImageRow(),
              const SizedBox(height: 24),

              // Botón de guardar (solo aparece si hay cambios)
              if (_hasChanges) _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: prefixIcon,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue;
          _checkForChanges();
        });
      },
      items: <String>['Mariscos', 'Carne', 'Pollo', 'Entrada']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, seleccione una categoría';
        }
        return null;
      },
    );
  }

  Widget _buildAvailabilityAndImageRow() {
    return Row(
      children: [
        // Switch de disponibilidad
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _available ? Colors.green[100] : Colors.red[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Switch(
            value: _available,
            onChanged: (bool value) {
              setState(() {
                _available = value;
                _checkForChanges();
              });
            },
            activeColor: Colors.green,
            inactiveThumbColor: Colors.red,
          ),
        ),
        const SizedBox(width: 16), // Espacio entre los elementos

        // Botón de Imagen Referencial
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Lógica para seleccionar una imagen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Seleccionar Imagen',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _savePlate(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 36, 49, 42),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: const Text(
          'Guardar Plato',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}