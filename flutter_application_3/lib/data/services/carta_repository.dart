import '../../config/supabase/supabase_config.dart';
import '../models/carta.dart';

class CartaRepository {
  final _client = SupabaseConfig.client;

  // Obtener cartas por restaurante
  Future<List<Carta>> getCartasByRestaurant(int restaurantId) async {
    final response = await _client
        .from('carta')
        .select()
        .eq('rest_cart', restaurantId);

    // Asegurar que el resultado es una lista de mapas antes de mapear
    if (response is List) {
      return response.map((json) => Carta.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Formato de datos inesperado: $response');
    }
  }

  // Crear carta
  Future<Carta> createCarta({
    required String type,
    required String description,
    required int restCart,
  }) async {
    final response = await _client
        .from('carta')
        .insert({
          'type': type, 
          'description': description,
          'rest_cart': restCart
        })
        .select()
        .single();

    return Carta.fromJson(response);
  }

  // Actualizar carta
  Future<void> updateCarta({
    required int cartaId,
    required String newDescription,
    required String userId,
  }) async {
    await _client
        .from('carta')
        .update({'description': newDescription})
        .eq('carta_id', cartaId)
        .eq('restaurants.id_dueno', userId);
  }
}
