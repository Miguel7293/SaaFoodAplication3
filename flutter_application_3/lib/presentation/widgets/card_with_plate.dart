import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/data/models/carta.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/services/carta_repository.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/presentation/widgets/plates_list_view.dart';

class CartaWithPlatesWidget extends StatelessWidget {
  final Restaurant restaurant;

  const CartaWithPlatesWidget({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Carta>>(
      future: CartaRepository().getCartasByRestaurant(restaurant.restaurantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final cartas = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cartas.map((carta) => _buildCartaSection(carta)).toList(),
        );
      },
    );
  }

  Widget _buildCartaSection(Carta carta) {
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
            Text(carta.type, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 215,
              child: PlatesListView(plates: plates),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
