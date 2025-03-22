import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/rate.dart';
import 'package:flutter_application_example/data/models/user.dart';
import 'package:flutter_application_example/data/services/rate_repository.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';


class RatingsTab extends StatelessWidget {
  final int restaurantId;

  const RatingsTab({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Rate>>(
      future: RateRepository().getRestaurantRates(restaurantId), // Obtiene ratings del restaurante
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Indicador de carga
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        
        final ratings = snapshot.data ?? [];
        if (ratings.isEmpty) {
          return const Center(child: Text("No hay calificaciones aún"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: ratings.length,
          itemBuilder: (context, index) {
            final rate = ratings[index];
            return FutureBuilder<User>(
              future: UserRepository().getUserById(rate.userRestaurantId), // Obtiene usuario
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasError || userSnapshot.data == null) {
                  return const SizedBox(); // No muestra nada si hay error en usuario
                }

                final user = userSnapshot.data!;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.profileImage),
                      radius: 25,
                    ),
                    title: Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (i) => Icon(
                            Icons.star,
                            color: i < rate.points ? Colors.orange : Colors.grey,
                            size: 20,
                          )),
                        ),
                        const SizedBox(height: 5),
                        Text(rate.description ?? " "),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
