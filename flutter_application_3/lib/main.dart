import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/supabase/supabase_config.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carga variables de entorno
  await dotenv.load(fileName: '.env');
  print('✅ Variables cargadas:');
  print('URL: ${dotenv.get('SUPABASE_URL')}');
  print('KEY: ${dotenv.get('SUPABASE_ANON_KEY')}');

  // Inicializa Supabase
  await SupabaseConfig.initialize();


final response = await SupabaseConfig.client
    .from('carta')
    .select(); // ¡Elimina el .execute()

print(response);

  runApp(const App());
}