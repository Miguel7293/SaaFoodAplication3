import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/data/services/rate_repository.dart';
import 'package:flutter_application_example/data/services/rating_calculate.dart';
import '../../../core/constants/main_colors.dart';
import 'package:flutter_application_example/data/models/rate.dart'; // Importa el modelo Rate

import '../screens/user_screens/rest_detail_screen.dart';

class RestaurantCard extends StatefulWidget {
  final Restaurant res;

  const RestaurantCard({super.key, required this.res});

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  late Future<List<Rate>> _ratesFuture;

  @override
  void initState() {
    super.initState();
    // Carga las calificaciones del restaurante cuando el widget se inicie
    _ratesFuture = RateRepository().getRestaurantRates(widget.res.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        widget.res.state == "Abierto" ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestDetailScreen(res: widget.res),
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
              _buildImage(widget.res.imageOfLocal ??
                  "https://e1.pngegg.com/pngimages/555/986/png-clipart-media-filetypes-jpg-icon-thumbnail.png"),
              FutureBuilder<List<Rate>>(
                future: _ratesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error al cargar las calificaciones');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildInfoSection(widget.res, statusColor,
                        0.0); // Si no hay calificaciones, mostramos 0
                  }

                  // Calcular la calificación promedio
                  List<Rate> rates = snapshot.data!;
                  double averageRating =
                      RatingUtils.calculateAverageRating(rates);

                  return _buildInfoSection(
                      widget.res, statusColor, averageRating);
                },
              ),
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
          child:
              const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        ),
      ),
    );
  }

  /// 📌 Sección de información del restaurante
  Widget _buildInfoSection(
      Restaurant res, Color statusColor, double averageRating) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(res.name,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          _buildCategoryAndRating(
              averageRating), // Muestra la calificación promedio
          const SizedBox(height: 5),
          _buildScheduleAndStatus(res, statusColor),
        ],
      ),
    );
  }

  /// 📌 Categoría y estrellas con soporte para decimales
  Widget _buildCategoryAndRating(double averageRating) {
    int fullStars = averageRating.floor(); // Número de estrellas completas
    bool hasHalfStar =
        (averageRating - fullStars) >= 0.5; // Si hay media estrella
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0); // Estrellas vacías

    return Row(
      children: [
        const Icon(Icons.restaurant, size: 18, color: Colors.grey),
        const SizedBox(width: 5),
        Text(widget.res.category ?? "sin categoría",
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(width: 10),
        Row(
          children: [
            ...List.generate(
                fullStars,
                (index) => const Icon(Icons.star,
                    size: 18, color: Colors.amber)), // 🌟 Estrellas llenas
            if (hasHalfStar)
              const Icon(Icons.star_half,
                  size: 18, color: Colors.amber), // ⭐️ Media estrella
            ...List.generate(
                emptyStars,
                (index) => const Icon(Icons.star_border,
                    size: 18, color: Colors.amber)), // ☆ Estrellas vacías
          ],
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
        Text(res.horario,
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(width: 10),
        Text(
          res.state ?? "default",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: statusColor),
        ),
      ],
    );
  }
}
