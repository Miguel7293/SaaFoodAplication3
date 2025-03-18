import 'package:flutter/material.dart';
import '../../widgets/plates_list_view.dart';
import '../../../data/models/plate_provider_prueba.dart';
import '../../../data/models/rest_provider_prueba.dart';
import 'plus_dishes.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  final myplates = PlateProvider.plates;
  final myrest = RestaurantProvider.restaurants;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name Of Restaurant'),
      ),
      body: SingleChildScrollView(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Carta Actual',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Desayuno',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10), 
            PlatesListView(plates: myplates),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Cartas Desactivadas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  const Text(
                    'Almuerzo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlusDishesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 30), // Botón '+'
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), 
            PlatesListView(plates: myplates), 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinear elementos
                children: [
                  const Text(
                    'Cena',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlusDishesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 30), // Botón '+'
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10), 
            PlatesListView(plates: myplates), 
          ],
        ),
      ),
    );
  }
}
