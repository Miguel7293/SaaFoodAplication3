import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/supabase/supabase_config.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  User? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  User? get currentUser => _currentUser;

  AuthProvider() {
    _setupAuthListener();
  }

  void _setupAuthListener() {
    SupabaseConfig.client.auth.onAuthStateChange.listen((AuthState data) {
      _currentUser = data.session?.user;
      _userId = _currentUser?.id;
      _isAuthenticated = _currentUser != null;
      notifyListeners();
    });
  }

  Future<void> loginWithGoogle() async {
    try {
      const webClientId =
          '546959425861-d4hlntkep2079qu2t5vjbdv8fklthndd.apps.googleusercontent.com';
      //const iosClientId = 'TU_CLIENT_ID_IOS'; // Opcional para iOS

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
        //clientId: iosClientId,
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;

      await SupabaseConfig.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );
    } catch (e) {
      print('Error Google SignIn: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().disconnect(); // Desconectar de Google
    } catch (e) {
      print('Error al cerrar sesión de Google: $e');
    }

    await SupabaseConfig.client.auth.signOut();
  }
}
