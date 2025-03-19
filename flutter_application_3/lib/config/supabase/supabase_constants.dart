import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConstants {
  static String get url => dotenv.get('SUPABASE_URL');
  static String get anonKey => dotenv.get('SUPABASE_ANON_KEY');
}