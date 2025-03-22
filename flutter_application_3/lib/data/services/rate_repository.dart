import 'package:flutter_application_example/config/supabase/supabase_config.dart';
import 'package:flutter_application_example/data/models/rate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RateRepository {
  final SupabaseClient _supabase = SupabaseConfig.client;

  Future<Rate> addRate(Rate rate) async {
    final response = await _supabase
        .from('rates')
        .insert({
          "points": rate.points,
          "description": rate.description,
          "user_restaurant": rate.userRestaurantId,
          "restaurant_id": rate.restaurantId,
          "created_at": rate.createdAt.toIso8601String(),
        })
        .select()
        .single();

    return Rate.fromJson(response);
  }

  Future<List<Rate>> getRestaurantRates(int restaurantId) async {
    final response = await _supabase
        .from('rates')
        .select()
        .eq('restaurant_id', restaurantId);

    return (response as List).map((e) => Rate.fromJson(e)).toList();
  }

// En RateRepository
Future<Rate> updateRate(Rate rate) async {
  try {
    if (rate.rateId == null) {
      throw ArgumentError('No se puede actualizar un rating sin ID');
    }

    final response = await _supabase
        .from('rates')
        .update(rate.toJson()..remove('rate_id')) // Excluir ID en el update
        .eq('rate_id', rate.rateId!)
        .select()
        .single()
        .timeout(const Duration(seconds: 5));

    return Rate.fromJson(response);
  } on PostgrestException catch (e) {
    if (e.code == 'PGRST116') { // Código de error cuando no se encuentra el registro
      throw Exception('Rating no encontrado con ID: ${rate.rateId}');
    }
    rethrow;
  }
}


  Future<bool> deleteRate(int rateId) async {
    final response = await _supabase
        .from('rates')
        .delete()
        .eq('rate_id', rateId)
        .select();

    return response.length > 0;
  }

  Future<List<Rate>> getUserRates(String userId) async { //obtenemos todos los rates del usuario
  final response = await _supabase
      .from('rates')
      .select()
      .eq('user_restaurant', userId) // Filtrar por el usuario autenticado
      .order('created_at', ascending: false); // Ordenar por fecha de creación

  return response.map<Rate>((json) => Rate.fromJson(json)).toList();
}
}
