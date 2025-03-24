import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/presentation/screens/user_screens/search_screen.dart';
import 'package:flutter_application_example/presentation/widgets/search_app_bar.dart';
import 'package:provider/provider.dart';
import '../../widgets/rest_list_view.dart';
import '../../../data/services/restaurant_repository.dart';
import '../../widgets/plates_list_view.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<Restaurant> allRestaurants = [];
  List<Plate> allPlates = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final restaurants =
        await Provider.of<RestaurantRepository>(context, listen: false)
            .getAllRestaurants();
    final plates = await PlateRepository().getAllPlates();

    if (mounted) {
      setState(() {
        allRestaurants = restaurants;
        allPlates = plates;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "SA Foods",
        onSearchPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchScreen(
                    allPlates: allPlates, allRestaurants: allRestaurants)),
          );
        },
      ),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: "RESTAURANTES CERCANOS"),
            RestaurantsListView(restaurants: allRestaurants),
            const SectionTitle(title: "HOT DEALS"),
            PlatesListView(plates: allPlates),
            const SectionTitle(title: "RECOMMENDATIONS"),
            PlatesListView(plates: allPlates),
            const SizedBox(height: 180),
          ],
        ),
      ),
    );
  }
}
