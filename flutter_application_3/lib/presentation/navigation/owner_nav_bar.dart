import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../../core/constants/main_colors.dart';
import '../../presentation/screens/owner_screens/main_owner_screen.dart';
import '../screens/owner_screens/profile_owner_screen.dart';

class MainOwnerNavBar extends StatefulWidget {
  const MainOwnerNavBar({super.key});

  @override
  State<MainOwnerNavBar> createState() => _MainOwnerNavBarState();
}

class _MainOwnerNavBarState extends State<MainOwnerNavBar> {
  int index = 0; 

  final screens = [
    OwnerHomeScreen(), 
    const SizedBox.shrink(), 
    OwnerProfileScreen(), 
  ];
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.map, size: 30), 
      const SizedBox.shrink(), 
      Icon(Icons.account_circle, size: 30), 
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