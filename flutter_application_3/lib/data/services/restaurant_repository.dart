import 'package:flutter/material.dart';

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
      return response
          .map((json) => Restaurant.fromJson(json as Map<String, dynamic>))
          .toList();
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
  Future<Restaurant?> getRestaurantById(int restaurantId) async {
    // NOTE CHECKED YET
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

  Future<List<Restaurant>> getRestaurantsByAuthenticatedUser(
      String userUid) async {
    try {
      debugPrint("🔍 Buscando restaurantes para el UID: $userUid");

      final response =
          await _client.from('restaurants').select().eq('id_dueno', userUid);

      if (response != null && response is List) {
        final restaurants =
            response.map((json) => Restaurant.fromJson(json)).toList();
        debugPrint("✅ Restaurantes obtenidos: ${restaurants.length}");
        return restaurants;
      } else {
        debugPrint("⚠️ No se encontraron restaurantes.");
        return [];
      }
    } catch (e) {
      debugPrint("❌ Error en getRestaurantsByAuthenticatedUser: $e");
      return [];
    }
  }

  Future<List<Restaurant>> getTopRatedRestaurants({int limit = 15}) async {
    try {
      final restaurants = await getAllRestaurants();

      // Obtener todas las calificaciones
      final ratesResponse = await _client.from('rates').select();

      if (ratesResponse == null ||
          ratesResponse.isEmpty ||
          ratesResponse is! List) {
        debugPrint("⚠️ No se encontraron ratings.");
        return [];
      }

      // Mapear los ratings a un mapa de restaurant_id -> lista de calificaciones
      final Map<int, List<int>> restaurantRatings = {};

      for (var rate in ratesResponse) {
        final int? restaurantId = rate['restaurant_id'];
        final int? rating = rate['points'];

        if (restaurantId != null && rating != null) {
          restaurantRatings.putIfAbsent(restaurantId, () => []).add(rating);
        }
      }

      // Calcular promedios y ordenar
      final ratedRestaurants = restaurants.map((restaurant) {
        final ratings = restaurantRatings[restaurant.restaurantId] ?? [];
        final double averageRating = ratings.isNotEmpty
            ? ratings.reduce((a, b) => a + b) / ratings.length
            : 0.0;
        return {'restaurant': restaurant, 'rating': averageRating};
      }).toList();

      ratedRestaurants.sort(
          (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));

      return ratedRestaurants
          .take(limit)
          .map((e) => e['restaurant'] as Restaurant)
          .toList();
    } catch (e) {
      debugPrint("❌ Error en getTopRatedRestaurants: $e");
      return [];
    }
  }

  Future<Restaurant?> getRestaurantByPlateId(int plateId) async {
    try {
      // Obtener el cart_id asociado al plate_id
      final plateResponse = await _client
          .from('plates')
          .select('cart_id')
          .eq('plate_id', plateId)
          .single();

      if (plateResponse == null || plateResponse is! Map<String, dynamic>) {
        return null;
      }

      final int? cartId = plateResponse['cart_id'];
      if (cartId == null) return null;

      // Obtener el restaurant_id asociado al cart_id
      final cartaResponse = await _client
          .from('carta')
          .select('rest_cart')
          .eq('carta_id', cartId)
          .single();

      if (cartaResponse == null || cartaResponse is! Map<String, dynamic>) {
        return null;
      }

      final int? restaurantId = cartaResponse['rest_cart'];
      if (restaurantId == null) return null;

      // Obtener los datos del restaurante
      return getRestaurantById(restaurantId);
    } catch (e) {
      debugPrint("❌ Error en getRestaurantByPlateId: $e");
      return null;
    }
  }
}
