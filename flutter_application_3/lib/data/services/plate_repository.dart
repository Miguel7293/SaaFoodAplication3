import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/supabase/supabase_config.dart';
import '../models/plate.dart';

class PlateRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Plate>> getAllPlates() async {
    final response = await _client.from('plates').select();
    return (response as List).map((e) => Plate.fromJson(e)).toList();
  }

  Future<Plate> getPlateById(int plateId) async {
    try {
      final response = await _client
          .from('plates')
          .select()
          .eq('plate_id', plateId)
          .single();
      return Plate.fromJson(response);
    } catch (e) {
      debugPrint('❌ Error obteniendo el plato por ID: $e');
      throw Exception('No se pudo obtener el plato con ID: $plateId');
    }
  }

  Future<List<Plate>> getPlatesByCartaId(int cartaId) async {
    final response =
        await _client.from('plates').select().eq('cart_id', cartaId);

    return (response as List).map((e) => Plate.fromJson(e)).toList();
  }

  Future<List<Plate>> getBestPricedPlates({int limit = 15}) async {
    try {
      final response = await _client
          .from('plates')
          .select()
          .order('price', ascending: true) // Ordena por precio ascendente
          .limit(limit); // Limita la cantidad de platos obtenidos

      return (response as List).map((e) => Plate.fromJson(e)).toList();
    } catch (e) {
      debugPrint('❌ Error obteniendo los platos con mejor precio: $e');
      return [];
    }
  }

  Future<Plate> addPlate(Plate plate) async {
    final data = plate.toJson();
    final response =
        await _client.from('plates').insert(data).select().single();

    return Plate.fromJson(response);
  }

  Future<Plate?> updatePlate(Plate plate) async {
    try {
      if (plate.plateId == 0) {
        throw ArgumentError('ID de plato inválido para actualización');
      }
      final response = await _client
          .from('plates')
          .update(plate.toJson()..remove('plate_id')) // Excluir ID en el update
          .eq('plate_id', plate.plateId!)
          .select()
          .single()
          .timeout(const Duration(seconds: 5));

      return Plate.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        // Código de error cuando no se encuentra el registro
        throw Exception('Rating no encontrado con ID: ${plate.plateId}');
      }
      rethrow;
    }
  }

  Future<bool> deletePlate(int plateId) async {
    try {
      final response = await _client
          .from('plates')
          .delete()
          .eq('plate_id', plateId)
          .select()
          .maybeSingle(); // Devuelve null si no hay filas

      return response != null;
    } catch (e) {
      debugPrint('❌ Error eliminando plato: $e');
      return false;
    }
  }
}
