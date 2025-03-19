import '../../config/supabase/supabase_config.dart';
import '../models/carta.dart';

class CartaRepository {
  final _client = SupabaseConfig.client;

  /// Obtiene todas las cartas registradas en la base de datos.
  /// 
  /// Retorna una lista de objetos `Carta`.
  /// 
  /// ### Uso:
  /// ```dart
  /// final cartas = await cartaRepository.getAllCartas();
  /// ```
  Future<List<Carta>> getAllCartas() async {
    final response = await _client.from('carta').select();

    if (response is List) {
      return response.map((json) => Carta.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Formato de datos inesperado: $response');
    }
  }

    /// Obtiene todas las cartas asociadas a un restaurante específico.
  /// 
  /// - [restaurantId]: ID del restaurante al que pertenecen las cartas.
  /// 
  /// Retorna una lista de objetos `Carta`.
  /// 
  /// ### Uso:
  /// ```dart
  /// final cartas = await cartaRepository.getCartasByRestaurant(18);
  /// ```
  Future<List<Carta>> getCartasByRestaurant(int restaurantId) async {
    final response = await _client
        .from('carta')
        .select()
        .eq('rest_cart', restaurantId);

    if (response is List) {
      return response.map((json) => Carta.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Formato de datos inesperado: $response');
    }
  }

}
