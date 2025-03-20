import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import '../../core/constants/main_colors.dart';
import '../screens/user_screens/plate_detail_screen.dart';

class CardPlates extends StatelessWidget {
  final Plate plate;

  const CardPlates({super.key, required this.plate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlateDetailScreen(plate: plate), // Carga la imagen HD aquí
          ),
        ),
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          elevation: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: plate.image,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholder: (context, url) =>
                        _buildLowResImage(plate.image),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 50, color: Colors.red),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  plate.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  "\$${plate.price?.toStringAsFixed(2) ?? '0.00'}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📌 Muestra una versión en baja resolución antes de la imagen real
  Widget _buildLowResImage(String highResUrl) {
    String lowResUrl = highResUrl.replaceAll(
        '.jpg', '_low.jpg'); // Simulación de baja resolución
    return Image.network(
      lowResUrl,
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 120,
        height: 120,
        color: Colors.grey[300], // Placeholder si no hay imagen de baja calidad
      ),
    );
  }
}
