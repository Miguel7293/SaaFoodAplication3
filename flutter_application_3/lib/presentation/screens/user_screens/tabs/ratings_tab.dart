import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';
import 'package:flutter_application_example/presentation/theme/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_example/data/models/rate.dart';
import 'package:flutter_application_example/data/models/user.dart';
import 'package:flutter_application_example/data/services/rate_repository.dart';
import 'package:flutter_application_example/data/services/rating_service.dart';
import 'package:flutter_application_example/data/services/user_repository.dart';
import 'package:flutter_application_example/presentation/providers/auth_provider.dart';
import 'package:flutter_application_example/presentation/widgets/rating_card.dart';
import 'package:flutter_application_example/presentation/widgets/rating_dialog.dart';

class RatingsTab extends StatefulWidget {
  final int restaurantId;

  const RatingsTab({super.key, required this.restaurantId});

  @override
  State<RatingsTab> createState() => _RatingsTabState();
}

class _RatingsTabState extends State<RatingsTab> {
  late RatingService _ratingService;
  late UserRepository _userRepo;
  late String? _userId;
  List<Rate> _ratings = [];
  double _averageRating = 0.0;
  Map<int, int> _ratingDistribution = {};

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
    _fetchRatings();
  }

  void _initializeRepositories() {
    _ratingService = RatingService(Provider.of<RateRepository>(context, listen: false));
    _userRepo = Provider.of<UserRepository>(context, listen: false);
    _userId = Provider.of<AuthProvider>(context, listen: false).userId;
  }

  Future<void> _fetchRatings() async {
    try {
      final ratings = await _ratingService.fetchRatings(widget.restaurantId);
      setState(() {
        _ratings = ratings;
        _averageRating = ratings.isNotEmpty ? ratings.map((e) => e.points).reduce((a, b) => a + b) / ratings.length : 0.0;
        _ratingDistribution = { for (int i = 1; i <= 5; i++) i: ratings.where((r) => r.points == i).length };
      });
    } catch (e) {
      debugPrint('❌ Error obteniendo ratings: $e');
    }
  }

  void _showRatingDialog({Rate? rate}) {
    showDialog(
      context: context,
      builder: (context) {
        return RatingDialog(
          initialStars: rate?.points,
          initialComment: rate?.description,
          onSave: (stars, comment) async {
            if (_userId == null) return;
            if (rate == null) {
              final newRate = Rate(
                points: stars,
                description: comment,
                userRestaurantId: _userId!,
                restaurantId: widget.restaurantId,
                createdAt: DateTime.now(),
              );
              await _ratingService.addRating(newRate);
            } else {
              final updatedRate = rate.copyWith(
                points: stars,
                description: comment,
              );
              await _ratingService.updateRating(updatedRate);
            }
            await _fetchRatings();
          },
        );
      },
    );
  }

  Widget _buildStarRow() {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (_averageRating >= i) {
        stars.add(const Icon(Icons.star, color: AppColors.smallItemsColor, size: 37));
      } else if (_averageRating > i - 1 && _averageRating < i) {
        stars.add(const Icon(Icons.star_half, color: AppColors.smallItemsColor, size: 37));
      } else {
        stars.add(const Icon(Icons.star_border, color: AppColors.smallItemsColor, size: 37));
      }
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: stars);
  }

  Widget _buildRatingDistribution() {
    return Padding(
      padding: const EdgeInsets.only(left: 21, right: 21),
      child: Column(
        children: _ratingDistribution.entries.map((entry) {
          return Row(
            children: [
              Text("${entry.key} ", style: const TextStyle(fontSize: 16)),
              const Icon(Icons.star, color: AppColors.smallItemsColor, size: 22),
              const SizedBox(width: 5),
              Expanded(
                child: LinearProgressIndicator(
                  value: entry.value / (_ratings.isNotEmpty ? _ratings.length : 1),
                  backgroundColor: Colors.grey[300],
                  color: AppColors.smallItemsColor,
                ),
              ),
              const SizedBox(width: 10),
              Text("${entry.value}", style: const TextStyle(fontSize: 14)),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text("Calificaciones", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildStarRow(),
        Text("${_averageRating.toStringAsFixed(1)} / 5", style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        _buildRatingDistribution(),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          style: AppStyles.buttonStyle(AppColors.descriptionPrimary),
          onPressed: () => _showRatingDialog(),
          icon: const Icon(Icons.rate_review),
          label: const Text("Dejar una calificación"),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _ratings.isEmpty
              ? const Center(child: Text("No hay calificaciones aún"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _ratings.length,
                  itemBuilder: (context, index) {
                    final rating = _ratings[index];
                    return FutureBuilder<User>(
                      future: _userRepo.getUserById(rating.userRestaurantId),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (userSnapshot.hasError || userSnapshot.data == null) {
                          return const SizedBox();
                        }
                        final user = userSnapshot.data!;
                        return RatingCard(
                          rating: rating,
                          user: user,
                          currentUserId: _userId,
                          onEdit: (rate) async {
                            _showRatingDialog(rate: rate);
                          },
                          onDelete: (rateId) async {
                            await _ratingService.deleteRating(rateId);
                            await _fetchRatings();
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
