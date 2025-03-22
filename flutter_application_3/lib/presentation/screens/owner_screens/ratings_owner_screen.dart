import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/user.dart'; 
import '../../../data/services/rate_repository.dart'; 
import '../../../data/services/user_repository.dart'; 
import '../../../data/services/restaurant_repository.dart'; 
import 'package:flutter_application_example/presentation/providers/auth_provider.dart';
import '../../../data/models/rate.dart'; 

class RatingsOwnerScreen extends StatefulWidget {
  const RatingsOwnerScreen({super.key});

  @override
  State<RatingsOwnerScreen> createState() => _RatingsOwnerScreenState();
}

class _RatingsOwnerScreenState extends State<RatingsOwnerScreen> {
  late RateRepository _rateRepo;
  late UserRepository _userRepo;
  late RestaurantRepository _restaurantRepo;
  late String? _userId;
  String? _restaurantId; 
  List<Rate> _ratings = []; 
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
    _fetchRestaurantId(); 
  }

  void _initializeRepositories() {
    _rateRepo = Provider.of<RateRepository>(context, listen: false);
    _userRepo = Provider.of<UserRepository>(context, listen: false);
    _restaurantRepo = Provider.of<RestaurantRepository>(context, listen: false);
    _userId = Provider.of<AuthProvider>(context, listen: false).userId;
  }

  Future<void> _fetchRestaurantId() async {
    try {
      final restaurants = await _restaurantRepo.getRestaurantsByAuthenticatedUser(_userId!);
      if (restaurants.isNotEmpty) {
        setState(() {
          _restaurantId = restaurants.first.restaurantId.toString();
        });
        _fetchRatings();
      } else {
        debugPrint("El usuario no tiene restaurantes asociados");
      }
    } catch (e) {
      debugPrint('❌ Error obteniendo el ID del restaurante: $e');
    }
  }

  Future<void> _fetchRatings() async {
    if (_restaurantId == null) return; // Si no hay ID, no hacer nada

    try {
      final restaurantId = int.parse(_restaurantId!); // Convierte String a int
      // Obtener las calificaciones del restaurante
      final ratings = await _rateRepo.getRestaurantRates(restaurantId);
      double total = ratings.fold(0, (sum, item) => sum + item.points);
      setState(() {
        _ratings = ratings;
        _averageRating = ratings.isNotEmpty ? total / ratings.length : 0.0;
      });
    } catch (e) {
      debugPrint('❌ Error obteniendo ratings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calificaciones'),
      ),
      body: _restaurantId == null
          ? const Center(child: CircularProgressIndicator()) 
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Calificación promedio: ${_averageRating.toStringAsFixed(1)}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: _ratings.isEmpty
                      ? const Center(child: Text("No hay calificaciones aún"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _ratings.length,
                          itemBuilder: (context, index) {
                            final rating = _ratings[index];
                            return FutureBuilder<User>(
                              future: _userRepo.getUserById(rating.userRestaurantId),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (userSnapshot.hasError || userSnapshot.data == null) {
                                  return const SizedBox(); 
                                }
                                final user = userSnapshot.data!;
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(user.profileImage),
                                          radius: 25,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.username,
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              Row(
                                                children: List.generate(5, (i) => Icon(
                                                  Icons.star,
                                                  color: i < rating.points ? Colors.orange : Colors.grey,
                                                  size: 20,
                                                )),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(rating.description ?? " "),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: Text(
                                                  "${rating.createdAt.toLocal()}",
                                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}