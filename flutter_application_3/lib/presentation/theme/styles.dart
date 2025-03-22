import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';

class AppStyles {
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.descriptionPrimary,
    foregroundColor: AppColors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static const TextStyle tittleTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.descriptionPrimary);

  static const TextStyle primaryTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle secondaryTextStyle = TextStyle(
    fontSize: 16,
    color: AppColors.grayDark,
  );

  static Widget detailImage(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8), // Bordes redondeados opcionales
      child: Image.network(
        imageUrl ??
            "https://e1.pngegg.com/pngimages/555/986/png-clipart-media-filetypes-jpg-icon-thumbnail.png",
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}
