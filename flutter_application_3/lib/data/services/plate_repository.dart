import '../../config/supabase/supabase_config.dart';
import '../models/plate.dart';

class PlateRepository {
  final _client = SupabaseConfig.client;

  /// Obtiene todos los platos registrados en la base de datos.
  /// 
  /// Retorna una lista de objetos `Plate`.
  /// 
  /// ### Uso:
  /// ```dart
  /// final plates = await plateRepository.getAllPlates();
  /// ```
  Future<List<Plate>> getAllPlates() async {
    final response = await _client.from('plates').select();

    if (response is List) {
      return response.map((json) => Plate.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Formato de datos inesperado: $response');
    }
  }

  /// Obtiene todos los platos asociados a una carta específica.
  /// 
  /// - [cartaId]: ID de la carta a la que pertenecen los platos.
  /// 
  /// Retorna una lista de objetos `Plate`.
  /// 
  /// ### Uso:
  /// ```dart
  /// final plates = await plateRepository.getPlatesByCartaId(1);
  /// ```
  Future<List<Plate>> getPlatesByCartaId(int cartaId) async {
    final response = await _client
        .from('plates')
        .select()
        .eq('cart_id', cartaId);

    if (response is List) {
      return response.map((json) => Plate.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Formato de datos inesperado: $response');
    }
  }
}
