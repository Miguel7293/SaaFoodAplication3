import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/presentation/theme/styles.dart';

class HorarioTab extends StatelessWidget {
  final Restaurant res;

  const HorarioTab({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        res.state == "Abierto" ? Colors.green : Colors.red;

    return Container(
      color: Colors.grey[100], // Fondo sutil
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppStyles.detailImage(res.imageOfLocal),
            const SizedBox(height: 10),
            Text(res.name, style: AppStyles.tittleTextStyle),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.restaurant, size: 20, color: Colors.grey),
                const SizedBox(width: 5),
                Text(res.category ?? "Categoría desconocida",
                    style: AppStyles.secondaryTextStyle),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.schedule, size: 20, color: Colors.grey),
                const SizedBox(width: 5),
                Text(res.horario, style: AppStyles.secondaryTextStyle),
                const SizedBox(width: 10),
                Text(res.state ?? "Estado desconocido",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, size: 20, color: Colors.grey),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {},
                  child: Text(res.contactNumber,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(res.description ?? "sin descripción",
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
