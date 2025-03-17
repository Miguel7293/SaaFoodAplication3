import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/main_colors.dart';
import 'package:flutter_application_example/screens/user_screens/main_user_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: UserHomeScreen(),
        ),
      ),
    );

    
  }
}