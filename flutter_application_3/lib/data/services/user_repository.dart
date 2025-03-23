import '../../config/supabase/supabase_config.dart';
import '../models/user.dart';


class UserRepository {
  final _client = SupabaseConfig.client;

  // Método existente (sin modificaciones)
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

    return User.fromJson(response as Map<String, dynamic>);
  }

  // Nuevo método para crear usuario
  Future<User> createUser({
    required String userUid,
    required String email,
    required String username,
    required String typeUser,
    String profileImage = '',
  }) async {
    final response = await _client.from('users').insert({
      'user_uid': userUid,
      'email': email,
      'username': username,
      'type_user': typeUser,
      'profile_image': profileImage,
    }).select().single();

    return User.fromJson(response);
  }

  // Nuevo método para actualizar usuario
  Future<User> updateUser({String? username, String? profileImage}) async { // NO PROVADO AUN
    final authUser = _client.auth.currentUser;
    if (authUser == null) throw Exception('Usuario no autenticado');

    final updateData = {
      if (username != null) 'username': username,
      if (profileImage != null) 'profile_image': profileImage,
    };

    final response = await _client
        .from('users')
        .update(updateData)
        .eq('user_uid', authUser.id)
        .select()
        .single();

    return User.fromJson(response);
  }

  // Nuevo método para eliminar usuario
  Future<void> deleteUser() async { // NO PROVADO AUN
    final authUser = _client.auth.currentUser;
    if (authUser == null) throw Exception('Usuario no autenticado');

    await _client.from('users').delete().eq('user_uid', authUser.id);
    await _client.auth.admin.deleteUser(authUser.id);
  }

    Future<User> getUserById(String userUid) async {
    final response = await _client
        .from('users')
        .select()
        .eq('user_uid', userUid)
        .single();

    return User.fromJson(response);
  }

  Future<void> updateUserType(String userUid, String newType) async {
    await _client.from('users')
      .update({'type_user': newType})
      .eq('user_uid', userUid);
  }
  
  Future<void> submitOwnerApplication(String userUid, String businessInfo) async {
    await _client.from('owner_applications').insert({
      'user_uid': userUid,
      'business_info': businessInfo,
      'status': 'pending'
    });
  }
}