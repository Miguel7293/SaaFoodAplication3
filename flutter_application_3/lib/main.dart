import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'core/constants/main_colors.dart';
import 'presentation/screens/user_screens/main_user_screen.dart';
import 'presentation/screens/user_screens/map_user_screen.dart';
import 'presentation/screens/user_screens/user_profile_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int index = 1;

  final screens = [
    MapUserScreen(),
    UserHomeScreen(),
    UserProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.map, size: 30),
      Icon(Icons.home, size: 30),
      Icon(Icons.account_circle, size: 30)
    ];


    return MaterialApp(
      home: Scaffold(
        extendBody: true,
        body: Center(
          child: screens[index],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          color: AppColors.backgroundLogin,
          backgroundColor: Colors.transparent,
          items: items,
          height: 60,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          index: index,
          onTap: (index) => setState(() {
            this.index = index;
          }),
        ),
      ),
    );
  }
}
