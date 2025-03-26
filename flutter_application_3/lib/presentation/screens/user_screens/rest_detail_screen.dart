import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/presentation/screens/user_screens/tabs/carta_tab.dart';
import 'package:flutter_application_example/presentation/screens/user_screens/tabs/horario_tab.dart';
import 'package:flutter_application_example/presentation/screens/user_screens/tabs/ratings_tab.dart';
import '../../../core/constants/main_colors.dart';

class RestDetailScreen extends StatelessWidget {
  final Restaurant res;

  const RestDetailScreen({super.key, required this.res});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(res.name,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: AppColors.appBackground,
          centerTitle: true,
          elevation: 4,
          bottom: const TabBar(
            indicatorColor: AppColors.descriptionPrimary,
            labelColor: AppColors.selectedBackgroundIcon,
            unselectedLabelColor: AppColors.backgroundIcon, 
            tabs: [
              Tab(icon: Icon(Icons.schedule), text: "Horario"),
              Tab(icon: Icon(Icons.restaurant_menu), text: "Cartas"),
              Tab(icon: Icon(Icons.star), text: "Ratings"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HorarioTab(res: res),
            CartasTab(res: res),
            RatingsTab(restaurantId: res.restaurantId),
          ],
        ),
      ),
    );
  }
}
