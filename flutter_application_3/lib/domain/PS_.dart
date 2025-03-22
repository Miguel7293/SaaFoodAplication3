import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/rate.dart';
import 'package:flutter_application_example/data/services/rate_repository.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:provider/provider.dart';
import '../data/services/carta_repository.dart';
import '../data/services/restaurant_repository.dart';
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
  late String? _userId;


  @override
  void initState() {
    super.initState();
    _initializeRepositories();
    cargarDatos();
  }

  void _initializeRepositories() {
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