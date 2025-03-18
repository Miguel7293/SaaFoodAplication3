import 'package:flutter/material.dart';
import '../../../core/constants/main_colors.dart';
import '../../../data/models/rest_provider_prueba.dart';
import '../screens/user_screens/rest_detail_screen.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant res;

  const RestaurantCard({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = res.state == "Abierto" ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestDetailScreen(res: res),
          ),
        ),
        child: Container(
          width: 260,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(res.imageOfLocal),
              _buildInfoSection(res, statusColor),
            ],
          ),
        ),
      ),
    );
  }

  /// 📌 Sección de la imagen con carga progresiva
  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 90,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 90,
            color: Colors.grey[300], // Placeholder
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          height: 90,
          color: Colors.grey[300],
          child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        ),
      ),
    );
  }

  /// 📌 Sección de información del restaurante
  Widget _buildInfoSection(Restaurant res, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(res.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          _buildCategoryAndRating(res),
          const SizedBox(height: 5),
          _buildScheduleAndStatus(res, statusColor),
        ],
      ),
    );
  }

  /// 📌 Categoría y estrellas
  Widget _buildCategoryAndRating(Restaurant res) {
    return Row(
      children: [
        const Icon(Icons.restaurant, size: 18, color: Colors.grey),
        const SizedBox(width: 5),
        Text(res.category, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(width: 10),
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              index < 4 ? Icons.star : Icons.star_border, // Simula 4 estrellas
              size: 18,
              color: Colors.amber,
            ),
          ),
        ),
      ],
    );
  }

  /// 📌 Horario y estado
  Widget _buildScheduleAndStatus(Restaurant res, Color statusColor) {
    return Row(
      children: [
        const Icon(Icons.schedule, size: 18, color: Colors.grey),
        const SizedBox(width: 5),
        Text(res.horario, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(width: 10),
        Text(
          res.state,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: statusColor),
        ),
      ],
    );
  }
}
