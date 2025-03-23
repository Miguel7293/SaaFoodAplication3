import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/models/rate.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/data/services/rate_repository.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:provider/provider.dart';
import '../data/services/carta_repository.dart';
import '../data/services/restaurant_repository.dart';
import '../presentation/providers/auth_provider.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

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
  late PlateRepository _plateRepo;
  late String? _userId;


  @override
  void initState() {
    super.initState();
    //_initializeRepositories();
    //cargarDatos();
    _procesarEmailRequest();
  }

  Future<void> _procesarEmailRequest() async {
    // Clave API de SendGrid (¡no la exponga en producción!)
    final String apiKey =
        'NOT HERE';

    // URL de la API de SendGrid
    final String url = 'https://api.sendgrid.com/v3/mail/send';

    // Construcción del mensaje
    final Map<String, dynamic> message = {
      "personalizations": [
        {
          "to": [
            {"email": "wtherosluw02@gmail.com"}
          ],
          "subject": "Hello from SendGrid"
        }
      ],
      "from": {"email": "solopaololuna@gmail.com"},
      "content": [
        {"type": "text/plain", "value": "Hello from SendGrid"},
        {"type": "text/html", "value": "<h1>Hello from SendGrid</h1>"}
      ]
    };

    try {
      // Realizar la solicitud POST a SendGrid
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 202) {
        print(">>>>>>>>>>>>>> Email sent...");
      } else {
        print(">>>>>>>>>>>>>> Error sending email: ${response.body}");
      }
    } catch (e) {
      print(">>>>>>>>>>>>>> Excepción al enviar email: $e");
    }
  }

  void _initializeRepositories() {
    _plateRepo = Provider.of<PlateRepository>(context, listen: false);
    _cartaRepo = Provider.of<CartaRepository>(context, listen: false);
    _restaurantRepo = Provider.of<RestaurantRepository>(context, listen: false);
    _userRepo = Provider.of<UserRepository>(context, listen: false);
    _rateRepo = Provider.of<RateRepository>(context, listen: false);
    _userId = Provider.of<AuthProvider>(context, listen: false).userId;
  }

  Future<void> cargarDatos() async {
   if (_userId == null) return;
    // ================== SECCIÓN DE CARTAS ==================
    await _procesarCartas();
    
    // ================== SECCIÓN DE RESTAURANTES ==================
    await _procesarRestaurantes();
    
    // ================== SECCIÓN DE USUARIO ==================
    await _procesarUsuario();
    
    // ================== SECCIÓN DE RATINGS ==================
    await _procesarRatings();

    // ================== SECCIÓN DE PLATES ==================
    await _procesarPlatos();
    
  }

  Future<void> _procesarCartas() async {
    if (_userId == null) return;

    debugPrint('\n🍽️ INICIANDO CARGA DE CARTAS 🍽️');
    
    try {
      // Carta específica
      const restaurantId = 23;
      final cartas = await _cartaRepo.getCartasByRestaurant(restaurantId);
      _logColeccion('CARTAS DEL RESTAURANTE $restaurantId', cartas.length);
      for (var carta in cartas) {
        debugPrint('│  ID: ${carta.cartaId} | Tipo: ${carta.type}');
      }

      // Todas las cartas
      final allCartas = await _cartaRepo.getAllCartas();
      _logColeccion('TODAS LAS CARTAS', allCartas.length);
    } catch (e) {
      _logError('CARTAS', e);
    }
  }

  Future<void> _procesarRestaurantes() async {
    debugPrint('\n🏨 INICIANDO CARGA DE RESTAURANTES 🏨');
    
    try {
      // Todos los restaurantes
      final restaurants = await _restaurantRepo.getAllRestaurants();
      _logColeccion('LISTA COMPLETA DE RESTAURANTES', restaurants.length);

      // Restaurante específico
      const targetRestaurantId = 4;
      final restaurant = await _restaurantRepo.getRestaurantById(targetRestaurantId);
      restaurant != null 
          ? debugPrint('✅ RESTAURANTE ENCONTRADO ID $targetRestaurantId')
          : debugPrint('⚠️ RESTAURANTE NO ENCONTRADO ID $targetRestaurantId');

    } catch (e) {
      _logError('RESTAURANTES', e);
    }
  }

  Future<void> _procesarUsuario() async {
    debugPrint('\n👤 INICIANDO CARGA DE USUARIO 👤');
    
    try {
      if (_userId == null) throw Exception('Usuario no autenticado');
      
      final user = await _userRepo.getAuthenticatedUser();
      debugPrint('''
      🔐 DATOS DE USUARIO
      ├─ UID: ${user.userUid}
      ├─ Email: ${user.email}
      └─ Tipo: ${user.typeUser}''');

      // Restaurantes del usuario
      final userRestaurants = await _restaurantRepo.getRestaurantsByAuthenticatedUser(user.userUid);
      _logColeccion('RESTAURANTES DEL USUARIO', userRestaurants.length);

    } catch (e) {
      _logError('USUARIO', e);
    }

    
  }

  Future<void> _procesarRatings() async {
    debugPrint('\n⭐ INICIANDO GESTIÓN DE RATINGS ⭐');
    
    try {
      if (_userId == null) throw Exception('Usuario no autenticado');
      
      const restaurantId = 21;
      final restaurant = await _restaurantRepo.getRestaurantById(restaurantId);
      if (restaurant == null) {
        debugPrint('⛔ RESTAURANTE NO ENCONTRADO PARA RATING');
        return;
      }

      // Creación de rating
      final newRate = Rate(
        points: 5,
        description: 'Excelente servicio inicial',
        userRestaurantId: _userId!,
        restaurantId: restaurantId,
        createdAt: DateTime.now(),
      );
      final createdRate = await _rateRepo.addRate(newRate);
      debugPrint('''
      📝 NUEVO RATING CREADO
      ├─ ID: ${createdRate.rateId}
      ├─ Puntos: ${createdRate.points}
      └─ Descripción: ${createdRate.description}''');

      // Actualización de rating
      final updatedRate = await _rateRepo.updateRate(
        Rate(
          rateId: createdRate.rateId,
          points: 4,
          description: 'Actualizado: Buen servicio pero lento',
          userRestaurantId: _userId!,
          restaurantId: restaurantId,
          createdAt: DateTime.now(),
        )
      );
      debugPrint('''
      ✏️ RATING ACTUALIZADO
      ├─ Nuevos puntos: ${updatedRate.points}
      └─ Nueva descripción: ${updatedRate.description}''');

      // Eliminación de rating
      if (updatedRate.rateId != null) {
        final deleted = await _rateRepo.deleteRate(updatedRate.rateId!);
        debugPrint(deleted ? '🗑️ RATING ELIMINADO' : '❌ ERROR ELIMINANDO RATING');
      }

      // Listado final de ratings
      final remainingRates = await _rateRepo.getRestaurantRates(restaurantId);
      _logColeccion('RATINGS RESTANTES', remainingRates.length);

    } catch (e) {
      _logError('RATINGS', e);
    }
  }

  
Future<void> _procesarPlatos() async {
  debugPrint('\n🍲 INICIANDO GESTIÓN DE PLATOS 🍲');

  try {
    // 1. Obtener una carta de ejemplo válida
    // Suponemos que usamos el ID de restaurante 21 para buscar cartas
    const restaurantId = 21;
    final cartas = await _cartaRepo.getCartasByRestaurant(restaurantId);

    if (cartas.isEmpty) {
      debugPrint('⛔ No hay cartas disponibles para el restaurante $restaurantId');
      return;
    }

    final cartaEjemplo = cartas.first;
    debugPrint('📋 Usando carta ID: ${cartaEjemplo.cartaId}');

    // 2. Crear un nuevo plato (sin plateId, pues se generará en la BD)
    final nuevoPlato = Plate(
      name: 'Paella Valenciana',
      description: 'Auténtica paella valenciana con mariscos',
      price: 15.99,
      available: true,
      image: 'https://ejemplo.com/paella.jpg',
      cartId: cartaEjemplo.cartaId, // Usamos el ID de la carta obtenida
      category: 'Platos principales',
    );

    final platoCreado = await _plateRepo.addPlate(nuevoPlato);
    debugPrint('🆕 Plato creado ID: ${platoCreado.plateId}');

    // 3. Actualizar el plato: cambiar precio y descripción
    final platoActualizado = await _plateRepo.updatePlate(
      platoCreado.copyWith(
        price: 17.99,
        description: 'Actualizado: Paella con mariscos y alioli',
      )
    );

    if (platoActualizado == null) {
      debugPrint('❌ Error actualizando el plato');
      return;
    }
    debugPrint('✏️ Plato actualizado: Nuevo precio ${platoActualizado.price}, Nueva descripción: ${platoActualizado.description}');

    // 4. Eliminar el plato
    final eliminado = await _plateRepo.deletePlate(platoActualizado.plateId!);
    debugPrint(eliminado ? '🗑️ Plato eliminado' : '❌ Error eliminando plato');

    // 5. Verificar: listar los platos restantes de la carta
    final platosRestantes = await _plateRepo.getPlatesByCartaId(cartaEjemplo.cartaId);
    _logColeccion('PLATOS RESTANTES', platosRestantes.length);

  } catch (e) {
    _logError('PLATOS', e);
  }
}

  // ================== HELPERS ==================
  void _logColeccion(String titulo, int cantidad) {
    debugPrint('📦 $titulo | Total: $cantidad');
  }

  void _logError(String seccion, dynamic error) {
    debugPrint('''
    ❌ ERROR EN $seccion
    ├─ Tipo: ${error.runtimeType}
    └─ Mensaje: ${error.toString()}''');
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}