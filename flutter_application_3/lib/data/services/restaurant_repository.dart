import '../../config/supabase/supabase_config.dart';
import '../models/restaurant.dart';

class RestaurantRepository {
  final _client = SupabaseConfig.client;

  /// Obtiene todos los restaurantes registrados en la base de datos.
  /// 
  /// Retorna una lista de objetos `Restaurant`.
  /// 
  /// ### Uso:
  /// ```dart
  /// final restaurants = await restaurantRepository.getAllRestaurants();
  /// ```
  Future<List<Restaurant>> getAllRestaurants() async {
    final response = await _client.from('restaurants').select();

    if (response is List) {
      return response.map((json) => Restaurant.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Formato de datos inesperado: $response');
    }
  }

  /// Obtiene un restaurante por su ID.
  /// 
  /// - [restaurantId]: ID del restaurante a obtener.
  /// 
  /// Retorna un objeto `Restaurant` o `null` si no existe.
  /// 
  /// ### Uso:
  /// ```dart
  /// final restaurant = await restaurantRepository.getRestaurantById(5);
  /// ```
  Future<Restaurant?> getRestaurantById(int restaurantId) async { // NOTE CHECKED YET
    final response = await _client
        .from('restaurants')
        .select()
        .eq('restaurant_id', restaurantId)
        .single();

    if (response != null && response is Map<String, dynamic>) {
      return Restaurant.fromJson(response);
    } else {
      return null;
    }
  }
}
