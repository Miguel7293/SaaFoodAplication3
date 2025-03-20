import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../core/constants/main_colors.dart';
import '../screens/user_screens/main_user_screen.dart';
import '../screens/user_screens/map_user_screen.dart';
import '../screens/user_screens/user_profile_screen.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  int _currentIndex = 1; // Índice inicial: Home
  
  final List<Widget> _screens = [
    const MapUserScreen(),      // Índice 0
    const UserHomeScreen(),     // Índice 1
    const UserProfileScreen()   // Índice 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: AppColors.backgroundLogin,
        backgroundColor: Colors.transparent,
        items: const [
          Icon(Icons.map, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.account_circle, size: 30),
        ],
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}