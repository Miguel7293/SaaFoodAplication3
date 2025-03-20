import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/data/services/carta_repository.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/presentation/widgets/plates_list_view.dart';
import '../../../../core/constants/main_colors.dart';
import '../../../../data/models/carta.dart';
import '../../../../data/models/plate.dart';

class RestDetailScreen extends StatelessWidget {
  final Restaurant res;

  const RestDetailScreen({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        res.state == "Abierto" ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(res.name),
        backgroundColor: AppColors.background,
      ),
      body: FutureBuilder<List<Carta>>(
        future: CartaRepository().getCartasByRestaurant(res.restaurantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final cartas = snapshot.data ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del restaurante
                Image.network(
                  res.imageOfLocal ?? "https://e1.pngegg.com/pngimages/555/986/png-clipart-media-filetypes-jpg-icon-thumbnail.png",
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y categoría
                      Text(
                        res.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.restaurant, size: 20, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(res.category ?? "Categoría desconocida",
                              style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Horario y Estado
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 20, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(res.horario, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                          const SizedBox(width: 10),
                          Text(
                            res.state ?? "Estado desconocido",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: statusColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Número de contacto
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 20, color: Colors.grey),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () => {},
                            child: Text(
                              res.contactNumber,
                              style: const TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Descripción
                      Text(
                        res.description ?? "sin descripción",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Cartas y sus platos (Usamos un widget separado para manejar FutureBuilder dentro de cada carta)
                      ...cartas.map((carta) => CartaWithPlatesWidget(carta: carta)).toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Widget que maneja cada carta con sus platos
class CartaWithPlatesWidget extends StatelessWidget {
  final Carta carta;

  const CartaWithPlatesWidget({super.key, required this.carta});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Plate>>(
      future: PlateRepository().getPlatesByCartaId(carta.cartaId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final plates = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              carta.type, // Mostrar el tipo de carta
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // Espacio para mostrar los platos horizontalmente
              child: PlatesListView(plates: plates),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
