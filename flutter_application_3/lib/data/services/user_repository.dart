import '../../config/supabase/supabase_config.dart';
import '../models/user.dart';

class UserRepository {
  final _client = SupabaseConfig.client;

  /// Obtiene los datos del usuario autenticado
  ///
  /// ### Uso:
  /// ```dart
  /// final user = await userRepository.getAuthenticatedUser();
  /// ```
  Future<User> getAuthenticatedUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      throw Exception('No hay un usuario autenticado');
    }

    final response = await _client
        .from('users')
        .select()
        .eq('user_uid', authUser.id)
        .single();

    if (response != null) {
      return User.fromJson(response as Map<String, dynamic>);
    } else {
      throw Exception('Usuario no encontrado en la base de datos');
    }
  }
}
