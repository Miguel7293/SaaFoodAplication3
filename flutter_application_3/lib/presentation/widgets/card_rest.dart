import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_example/data/models/restaurant.dart';
import 'package:flutter_application_example/data/services/rate_repository.dart';
import 'package:flutter_application_example/data/services/rating_calculate.dart';
import '../../../core/constants/main_colors.dart';
import 'package:flutter_application_example/data/models/rate.dart';
import '../screens/user_screens/rest_detail_screen.dart';

class RestaurantCard extends StatefulWidget {
  final Restaurant res;

  const RestaurantCard({super.key, required this.res});

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  double? averageRating;

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheHighResImage(widget.res.imageOfLocal);
  }

  Future<void> _loadRatings() async {
    List<Rate> rates = await RateRepository().getRestaurantRates(widget.res.restaurantId);
    if (mounted) {
      setState(() {
        averageRating = rates.isNotEmpty ? RatingUtils.calculateAverageRating(rates) : 0.0;
      });
    }
  }

  void _precacheHighResImage(String? imageUrl) {
    if (imageUrl != null) {
      precacheImage(NetworkImage(imageUrl), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = widget.res.state == "Abierto" ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RestDetailScreen(res: widget.res)),
        ),
        child: Container(
          width: 260,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(widget.res.imageOfLocal),
              _buildInfoSection(widget.res, statusColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    String placeholderImage = "https://e1.pngegg.com/pngimages/555/986/png-clipart-media-filetypes-jpg-icon-thumbnail.png";

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? placeholderImage,
        width: double.infinity,
        height: 90,
        fit: BoxFit.cover,
        memCacheWidth: 600,
        fadeInDuration: const Duration(milliseconds: 200),
        placeholder: (_, __) => _loadingPlaceholder(),
        errorWidget: (_, __, ___) => _errorPlaceholder(),
      ),
    );
  }

  Widget _loadingPlaceholder() {
    return Container(
      height: 90,
      color: Colors.grey[300],
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      height: 90,
      color: Colors.grey[300],
      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
    );
  }

  Widget _buildInfoSection(Restaurant res, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(res.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          _buildCategoryAndRating(),
          const SizedBox(height: 5),
          _buildScheduleAndStatus(res, statusColor),
        ],
      ),
    );
  }

  Widget _buildCategoryAndRating() {
    double rating = averageRating ?? 0.0;
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        _buildIconText(Icons.restaurant, widget.res.category ?? "Sin categoría"),
        const SizedBox(width: 10),
        Row(
          children: [
            ...List.generate(fullStars, (_) => const Icon(Icons.star, size: 18, color: Colors.amber)),
            if (hasHalfStar) const Icon(Icons.star_half, size: 18, color: Colors.amber),
            ...List.generate(emptyStars, (_) => const Icon(Icons.star_border, size: 18, color: Colors.amber)),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleAndStatus(Restaurant res, Color statusColor) {
    return Row(
      children: [
        _buildIconText(Icons.schedule, res.horario),
        const SizedBox(width: 10),
        Text(
          res.state ?? "Estado desconocido",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: statusColor),
        ),
      ],
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
