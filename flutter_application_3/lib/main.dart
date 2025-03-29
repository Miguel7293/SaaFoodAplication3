import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/data/services/provider/data_provider.dart';
import 'package:flutter_application_example/data/services/rate_repository.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'config/supabase/supabase_config.dart';
import 'data/services/carta_repository.dart';
import 'data/services/restaurant_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/carta_notifier.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await SupabaseConfig.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider(create: (_) => CartaRepository()),
        Provider(create: (_) => RestaurantRepository()),
        Provider(create: (_) => UserRepository()),
        Provider(create: (_) => RateRepository()),
        Provider(create: (_) => PlateRepository()),

        ChangeNotifierProvider(create: (_) => CartaProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),

      ],
      child: const App(),
    ),
  );
}
