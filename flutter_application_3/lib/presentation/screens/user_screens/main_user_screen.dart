import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:flutter_application_example/data/services/provider/data_provider.dart';
import 'package:flutter_application_example/presentation/screens/user_screens/search_screen.dart';
import 'package:flutter_application_example/presentation/widgets/search_app_bar.dart';
import 'package:provider/provider.dart';
import '../../widgets/rest_list_view.dart';
import '../../widgets/plates_list_view.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<DataProvider>(context, listen: false).fetchData());
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "SA Foods",
        onSearchPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(
                allPlates: dataProvider.allPlates,
                allRestaurants: dataProvider.restaurants,
              ),
            ),
          );

          if (dataProvider.allPlates.isEmpty || dataProvider.restaurants.isEmpty) {
            Future.microtask(() => dataProvider.fetchData());
          }
        },
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          if (dataProvider.isLoading && dataProvider.allPlates.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (dataProvider.hasError) {
            return const Center(child: Text("Error al cargar datos"));
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: 180),
            children: [
              const SectionTitle(title: "RESTAURANTES RECOMENDADOS"),
              RestaurantsListView(restaurants: dataProvider.topRatedRestaurants),
              const SectionTitle(title: "MEJORES PRECIOS"),
              PlatesListView(plates: dataProvider.bestPricedPlates),
              const SectionTitle(title: "PLATOS CERCA DE TI"),
              PlatesListView(plates: dataProvider.allPlates),
            ],
          );
        },
      ),
    );
  }
}
