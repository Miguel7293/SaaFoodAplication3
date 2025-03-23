import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/models/rate.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/data/services/rate_repository.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/user.dart';
import '../../../providers/auth_provider.dart';


class RatingsTab extends StatefulWidget {
  final int restaurantId;

  const RatingsTab({super.key, required this.restaurantId});

  @override
  State<RatingsTab> createState() => _RatingsTabState();
}

class _RatingsTabState extends State<RatingsTab> {
  late RateRepository _rateRepo;
  late UserRepository _userRepo;
  late String? _userId;
  List<Rate> _ratings = [];
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
    _fetchRatings();
  }

  void _initializeRepositories() {
    _rateRepo = Provider.of<RateRepository>(context, listen: false);
    _userRepo = Provider.of<UserRepository>(context, listen: false);
    _userId = Provider.of<AuthProvider>(context, listen: false).userId;
  }

  Future<void> _fetchRatings() async {
    try {
      final ratings = await _rateRepo.getRestaurantRates(widget.restaurantId);
      double total = ratings.fold(0, (sum, item) => sum + item.points);
      setState(() {
        _ratings = ratings;
        _averageRating = ratings.isNotEmpty ? total / ratings.length : 0.0;
      });
    } catch (e) {
      debugPrint('❌ Error obteniendo ratings: $e');
    }
  }

  Future<void> _deleteRating(int rateId) async {
    try {
      final success = await _rateRepo.deleteRate(rateId);
      if (success) {
        await _fetchRatings(); // Recargar las calificaciones
      }
    } catch (e) {
      debugPrint('❌ Error eliminando rating: $e');
    }
  }


  void _showRatingDialog() {
  int selectedStars = 5; // Valor predeterminado de estrellas seleccionadas
  TextEditingController commentController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Calificar Restaurante"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < selectedStars ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedStars = index + 1; // Actualizar estrellas seleccionadas
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: commentController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Escribe tu comentario",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cerrar el diálogo
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              _addRating(selectedStars, commentController.text); // Agregar la calificación
              Navigator.pop(context); // Cerrar el diálogo
            },
            child: const Text("Enviar"),
          ),
        ],
      );
    },
  );
}

Future<void> _addRating(int stars, String comment) async {
  if (_userId == null) return; // Si no hay usuario autenticado, no hacer nada

  final newRate = Rate(
    points: stars,
    description: comment,
    userRestaurantId: _userId!,
    restaurantId: widget.restaurantId,
    createdAt: DateTime.now(),
  );

  try {
    await _rateRepo.addRate(newRate); // Agregar la calificación al repositorio
    await _fetchRatings(); // Recargar la lista de calificaciones
  } catch (e) {
    debugPrint('❌ Error al agregar rating: $e');
  }
}



  Future<void> _editRating(Rate rate) async {
    int selectedStars = rate.points;
    TextEditingController commentController = TextEditingController(text: rate.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text("Editar Calificación"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < selectedStars ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedStars = index + 1;
                      });
                    },
                  ),
                ),
              ),
              TextField(
                controller: commentController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: "Edita tu comentario",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedRate = rate.copyWith(
                  points: selectedStars,
                  description: commentController.text,
                );
                await _rateRepo.updateRate(updatedRate);
                await _fetchRatings(); // Recargar las calificaciones
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text("Calificaciones", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        // Promedio de calificación
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => Icon(
              index < _averageRating ? Icons.star : Icons.star_border,
              color: Colors.orange,
              size: 30,
            ),
          ),
        ),
        Text("${_averageRating.toStringAsFixed(1)} / 5", style: const TextStyle(fontSize: 16)),

        const SizedBox(height: 20),

        // Botón para calificar
        ElevatedButton.icon(
          onPressed: _showRatingDialog,
          icon: const Icon(Icons.rate_review),
          label: const Text("Dejar una calificación"),
        ),

        const SizedBox(height: 20),

        // Lista de calificaciones
        Expanded(
          child: _ratings.isEmpty
              ? const Center(child: Text("No hay calificaciones aún"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _ratings.length,
                  itemBuilder: (context, index) {
                    final rating = _ratings[index];
                    return FutureBuilder<User>(
                      future: _userRepo.getUserById(rating.userRestaurantId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (userSnapshot.hasError || userSnapshot.data == null) {
                          return const SizedBox(); // No mostrar nada si hay error
                        }

                        final user = userSnapshot.data!;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(user.profileImage),
                                  radius: 25,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Row(
                                        children: List.generate(5, (i) => Icon(
                                          Icons.star,
                                          color: i < rating.points ? Colors.orange : Colors.grey,
                                          size: 20,
                                        )),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(rating.description ?? " "),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "${rating.createdAt.toLocal()}",
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      // Botones de editar y eliminar (solo si es del usuario actual)
                                      if (_userId == rating.userRestaurantId)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit, color: Colors.blue),
                                              onPressed: () => _editRating(rating),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () => _deleteRating(rating.rateId!),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}