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
    const MapUserScreen(), // Índice 0
    const UserHomeScreen(), // Índice 1
    const UserProfileScreen() // Índice 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: AppColors.backgroundLogin, // Color de la barra
        backgroundColor: Colors.transparent, // Fondo detrás de la barra
        buttonBackgroundColor: AppColors.appBackground, // Fondo del ítem seleccionado
        height: 60,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        items: List.generate(3, (index) {
          return Icon(
            [
              Icons.map,
              Icons.home,
              Icons.account_circle
            ][index], // Íconos en orden
            size: 30,
            color: _currentIndex == index
                ? AppColors.selectedBackgroundIcon //color seleccionado
                : AppColors.backgroundIcon, //color no seleccionados
          );
        }),
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
