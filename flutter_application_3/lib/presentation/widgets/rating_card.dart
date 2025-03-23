import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/rate.dart';
import 'package:flutter_application_example/data/models/user.dart';

class RatingCard extends StatelessWidget {
  final Rate rating;
  final User user;
  final String? currentUserId;
  final Function(Rate) onEdit;
  final Function(int) onDelete;

  const RatingCard({
    Key? key,
    required this.rating,
    required this.user,
    required this.currentUserId,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de perfil
            CircleAvatar(
              backgroundImage: NetworkImage(user.profileImage),
              radius: 25,
              onBackgroundImageError: (exception, stackTrace) {
                debugPrint("Error cargando la imagen: $exception");
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre de usuario
                  Text(user.username.isNotEmpty ? user.username : "Usuario desconocido",
                      style: const TextStyle(fontWeight: FontWeight.bold)),

                  // Estrellas de la calificación
                  Row(
                    children: List.generate(5, (i) => Icon(
                      Icons.star,
                      color: i < rating.points ? Colors.orange : Colors.grey,
                      size: 20,
                    )),
                  ),
                  const SizedBox(height: 5),
                  // Descripción de la calificación
                  Text(rating.description ?? " "),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "${rating.createdAt.toLocal()}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  // Botones de editar y eliminar solo si es del usuario actual
                  if (currentUserId == rating.userRestaurantId)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => onEdit(rating),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => onDelete(rating.rateId!),
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
  }
}
