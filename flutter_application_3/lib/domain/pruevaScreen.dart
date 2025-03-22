import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/rate.dart';
import 'package:flutter_application_example/data/services/rate_repository.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:provider/provider.dart';
import '../data/services/carta_repository.dart';
import '../data/services/restaurant_repository.dart'; // Asegúrate de importar esto
import '../presentation/providers/auth_provider.dart';

class PruevaScreen extends StatefulWidget {
  const PruevaScreen({super.key});

  @override
  State<PruevaScreen> createState() => _PruevaScreenState();
}

class _PruevaScreenState extends State<PruevaScreen> {

  late CartaRepository _cartaRepo;
  late RestaurantRepository _restaurantRepo;
  late UserRepository _userRepo;
  late RateRepository _rateRepo; 

  @override
  void initState() {
    super.initState();
    _cartaRepo = Provider.of<CartaRepository>(context, listen: false);
    _restaurantRepo = Provider.of<RestaurantRepository>(context, listen: false);
    _userRepo = Provider.of<UserRepository>(context, listen: false);
    _rateRepo = Provider.of<RateRepository>(context, listen: false);

    cargarDatos();
  }

  Future<void> cargarDatos() async {
    // Obtener cartas de un restaurante específico
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId;
      if (userId == null) throw Exception('Usuario no autenticado');

      const restaurantId = 23;
      final cartas = await _cartaRepo.getCartasByRestaurant(restaurantId);

      debugPrint("Cartas del Restaurante ----->");
      for (var carta in cartas) {
        debugPrint("ID: ${carta.cartaId}, Tipo: ${carta.type}, Descripción: ${carta.description}, RestCart: ${carta.restCart}, Actualizado: ${carta.updatedAt}");
      }
    } catch (e) {
      debugPrint("Error al obtener cartas del restaurante: $e");
    }

    // Obtener todas las cartas
    try {
      final allCartas = await _cartaRepo.getAllCartas();

      debugPrint("Todas las Cartas ----->");
      for (var carta in allCartas) {
        debugPrint("ID: ${carta.cartaId}, Tipo: ${carta.type}, Descripción: ${carta.description}, RestCart: ${carta.restCart}, Actualizado: ${carta.updatedAt}");
      }
    } catch (e) {
      debugPrint("Error al obtener todas las cartas: $e");
    }

    // Obtener todos los restaurantes
    try {
      final restaurants = await _restaurantRepo.getAllRestaurants();

      debugPrint("Restaurantes ----->");
      for (var restaurant in restaurants) {
        debugPrint("ID: ${restaurant.restaurantId}, Nombre: ${restaurant.name}, Ubicación: ${restaurant.location}, Contacto: ${restaurant.contactNumber}, Horario: ${restaurant.horario}, Estado: ${restaurant.state}, Dueño: ${restaurant.idDueno}, Creado: ${restaurant.createdAt}");
      }
    } catch (e) {
      debugPrint("Error al obtener restaurantes: $e");
    }

    // Obtener el usuario authenticated
    try {
      final user = await _userRepo.getAuthenticatedUser();
      debugPrint("Usuario Autenticado ----->");
      debugPrint("UID: ${user.userUid}, Email: ${user.email}, Nombre: ${user.username}, Tipo: ${user.typeUser}, Registrado: ${user.createdAt}");
    
    } catch (e){
      debugPrint("Error al obtener usuario: $e");
    }


        // Obtener un restaurante por ID
    try {
      const restaurantId = 4;
      final restaurant = await _restaurantRepo.getRestaurantById(restaurantId);

      if (restaurant != null) {
        debugPrint("Restaurante encontrado ----->");
        debugPrint("ID: ${restaurant.restaurantId}, Nombre: ${restaurant.name}, Ubicación: ${restaurant.location}, Contacto: ${restaurant.contactNumber}, Horario: ${restaurant.horario}, Estado: ${restaurant.state}, Dueño: ${restaurant.idDueno}, Creado: ${restaurant.createdAt}");
      } else {
        debugPrint("No se encontró el restaurante con ID: $restaurantId");
      }
    } catch (e) {
      debugPrint("Error al obtener restaurante por ID: $e");
    }

    try {
    // Obtener el usuario autenticado
    final user = await _userRepo.getAuthenticatedUser();
    final userUid = user.userUid; 

    debugPrint("Usuario Autenticado ----->");
    debugPrint("UID: $userUid, Email: ${user.email}, Nombre: ${user.username}");

    // Obtener los restaurantes relacionados con el usuario autenticado
    final restaurants = await _restaurantRepo.getRestaurantsByAuthenticatedUser(userUid);

    debugPrint("Restaurantes del Usuario ----->");
    for (var restaurant in restaurants) {
      debugPrint("ID: ${restaurant.restaurantId}, Nombre: ${restaurant.name}, Ubicación: ${restaurant.location}, Contacto: ${restaurant.contactNumber}");
    }
    } catch (e) {
      debugPrint("Error al obtener restaurantes del usuario autenticado: $e");
    }

        // 1. Ejemplo de creación de rating
  try {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userId;
    
    if (userId == null) {
      debugPrint("Usuario no autenticado");
      return;
    }

    // 1. Verificar existencia del restaurante
    const restaurantId = 21;
    final restaurant = await _restaurantRepo.getRestaurantById(restaurantId);
    if (restaurant == null) {
      debugPrint("⚠️ Restaurante $restaurantId no existe");
      return;
    }

    // 2. CRUD Completo de Ratings
    try {
      // Crear Rating
      final newRate = Rate(
        points: 5,
        description: 'Excelente servicio inicial',
        userRestaurantId: userId,
        restaurantId: restaurantId,
        createdAt: DateTime.now(),
      );

      final createdRate = await _rateRepo.addRate(newRate);
      debugPrint("""
      Rating creado ----->
      ID: ${createdRate.rateId}
      Puntos: ${createdRate.points}
      Descripción: ${createdRate.description}
      """);

      // Actualizar Rating
      final updatedRate = await _rateRepo.updateRate(
        createdRate.copyWith(
          points: 4,
          description: 'Actualizado: Buen servicio pero lento',
          createdAt: DateTime.now(),
        )
      );
      debugPrint("""
      Rating actualizado ----->
      Nuevos puntos: ${updatedRate.points}
      Nueva descripción: ${updatedRate.description}
      """);

      // Obtener y mostrar ratings actualizados
      final rates = await _rateRepo.getRestaurantRates(restaurantId);
      debugPrint("Total ratings actuales: ${rates.length}");

      // Antes de eliminar
      if (updatedRate.rateId == null || updatedRate.rateId == 0) {
        debugPrint("⚠️ Error: rateId inválido: ${updatedRate.rateId}");
        return;
      }

      
      // Eliminar Rating
      if (updatedRate.rateId != null) {
        final deleted = await _rateRepo.deleteRate(updatedRate.rateId!);
        debugPrint(deleted ? "✅ Rating eliminado" : "❌ Error eliminando");
        
        // Verificación post-eliminación
        final remainingRates = await _rateRepo.getRestaurantRates(restaurantId);
        debugPrint("Ratings restantes: ${remainingRates.length}");
      }
    } catch (e) {
      debugPrint("Error general en CRUD: $e");
    }


    final userRates = await _rateRepo.getUserRates(userId);

    if (userRates.isEmpty) {
      print("📢 El usuario no tiene calificaciones registradas.");
    } else {
      print("📋 Lista de calificaciones del usuario:");
      for (var rate in userRates) {
        print("⭐ Rate ID: ${rate.rateId}");
        print("   Puntos: ${rate.points}");
        print("   Descripción: ${rate.description ?? 'Sin descripción'}");
        print("   Restaurante ID: ${rate.restaurantId}");
        print("   Fecha: ${rate.createdAt}");
        print("------------------------");
      }
    }

  } catch (e) {
    debugPrint("Error en carga de datos: ${e.toString()}");
  }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // No renderiza nada en pantalla
  }
}
