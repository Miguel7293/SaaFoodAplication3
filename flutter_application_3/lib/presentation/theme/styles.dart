import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';

class AppStyles {
  static AppBar appBar(String title) {

    return AppBar(
      title: Text(title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      backgroundColor: AppColors.appBackground,
      centerTitle: true,
      elevation: 4, 
    );
  }

  static ButtonStyle buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

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
