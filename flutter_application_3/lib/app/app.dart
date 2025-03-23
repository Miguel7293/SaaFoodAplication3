import 'package:flutter/material.dart';
//import 'package:flutter_application_example/domain/pruevaScreen.dart';
import 'package:flutter_application_example/presentation/navigation/owner_nav_bar.dart';
import 'package:flutter_application_example/presentation/screens/auth/choosing_role_screen.dart';
import 'package:flutter_application_example/presentation/screens/auth/owner_survey_screen.dart';
import 'package:flutter_application_example/presentation/screens/auth/waiting_approval_screen.dart';
import 'package:provider/provider.dart';
import '../presentation/navigation/main_nav_bar.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/signup_screen.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(), // posiblemente lo quitemos
          '/customer': (context) => const MainNavBar(), // cliente
          '/owner': (context) => const MainOwnerNavBar(), // dueño
          '/choosing-role': (context) => const ChoosingRoleScreen(),
          '/owner-survey': (context) => const OwnerSurveyScreen(),
          '/waiting-approval': (context) => const WaitingApprovalScreen(),


        },
      ),
    );
  }
}