import 'package:flutter_application_example/data/models/rate.dart';
import 'package:flutter_application_example/data/services/rate_repository.dart';

class RatingService {
  final RateRepository _rateRepo;

  RatingService(this._rateRepo);

  Future<List<Rate>> fetchRatings(int restaurantId) async {
    return await _rateRepo.getRestaurantRates(restaurantId);
  }

  Future<void> addRating(Rate rate) async {
    await _rateRepo.addRate(rate);
  }

  Future<void> updateRating(Rate rate) async {
    await _rateRepo.updateRate(rate);
  }

  Future<void> deleteRating(int rateId) async {
    await _rateRepo.deleteRate(rateId);
  }
}
