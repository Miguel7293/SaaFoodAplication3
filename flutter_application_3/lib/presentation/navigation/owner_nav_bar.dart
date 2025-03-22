import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../core/constants/main_colors.dart';
import '../../presentation/screens/owner_screens/main_owner_screen.dart';
import '../screens/owner_screens/profile_owner_screen.dart';
import '../screens/owner_screens/ratings_owner_screen.dart';

class MainOwnerNavBar extends StatefulWidget {
  const MainOwnerNavBar({super.key});

  @override
  State<MainOwnerNavBar> createState() => _MainOwnerNavBarState();
}

class _MainOwnerNavBarState extends State<MainOwnerNavBar> {
  int index = 0;

  // Lista de screens (tipada como List<StatefulWidget>)
  final List<StatefulWidget> screens = [
    const OwnerHomeScreen(),
    const RatingsOwnerScreen(),
    const OwnerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Ítems de la barra de navegación
    final items = <Widget>[
      const Icon(Icons.home, size: 30),
      const Icon(Icons.star, size: 30),
      const Icon(Icons.account_circle, size: 30),
    ];

    return MaterialApp(
      home: Scaffold(
        extendBody: true,
        body: screens[index], 
        bottomNavigationBar: CurvedNavigationBar(
          color: AppColors.backgroundLogin,
          backgroundColor: Colors.transparent,
          items: items,
          height: 60,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          index: index,
          onTap: (index) => setState(() {
            this.index = index; 
          }),
        ),
      ),
    );
  }
}