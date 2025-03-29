import 'package:flutter/material.dart';
import 'package:flutter_application_example/data/services/plate_repository.dart';
import 'package:flutter_application_example/data/services/restaurant_repository.dart';
import 'package:flutter_application_example/data/models/plate.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';

class DataProvider extends ChangeNotifier {
  final RestaurantRepository _restaurantRepo = RestaurantRepository();
  final PlateRepository _plateRepo = PlateRepository();

  List<Restaurant> _restaurants = [];
  List<Restaurant> _topRatedRestaurants = [];
  List<Plate> _allPlates = [];
  List<Plate> _bestPricedPlates = [];

  bool _isLoading = false;
  bool _hasError = false;

  List<Restaurant> get restaurants => _restaurants;
  List<Restaurant> get topRatedRestaurants => _topRatedRestaurants;
  List<Plate> get allPlates => _allPlates;
  List<Plate> get bestPricedPlates => _bestPricedPlates;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> fetchData() async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      _restaurants = await _restaurantRepo.getAllRestaurants();
      _topRatedRestaurants = await _restaurantRepo.getTopRatedRestaurants();
      _allPlates = await _plateRepo.getAllPlates();
      _bestPricedPlates = await _plateRepo.getBestPricedPlates();

      _isLoading = false;
    } catch (e) {
      _hasError = true;
    } finally {
      notifyListeners();
    }
  }
}
