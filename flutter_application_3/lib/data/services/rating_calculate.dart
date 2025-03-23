import 'package:flutter_application_example/data/models/rate.dart';

class RatingUtils {
  static double calculateAverageRating(List<Rate> ratings) {
    if (ratings.isEmpty) return 0.0;
    double total = ratings.fold(0, (sum, item) => sum + item.points);
    return total / ratings.length;
  }
}
