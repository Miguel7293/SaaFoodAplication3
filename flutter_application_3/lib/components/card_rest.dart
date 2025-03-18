import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/main_colors.dart';
import 'package:flutter_application_example/data/rest_provider_prueba.dart';
import 'package:flutter_application_example/screens/user_screens/rest_detail_screen.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant res;

  const RestaurantCard({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        res.state == "Abierto" ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.all(7.0),
      //Tarjetas
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
              // Imagen
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  res.imageOfLocal,
                  width: double.infinity,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre
                    Text(
                      res.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),

                    // Categoría y Estrellas
                    Row(
                      children: [
                        const Icon(Icons.restaurant,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(res.category,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey)),
                        const SizedBox(width: 10),
                        // Estrellas
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < 4
                                  ? Icons.star
                                  : Icons.star_border, // Simula 4 estrellas
                              size: 18,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    // Horario
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          res.horario,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(width: 10),
                        // Estado
                        Text(
                          res.state,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: statusColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
