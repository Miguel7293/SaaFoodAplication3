import 'package:flutter/material.dart';
import '../../core/constants/main_colors.dart';
import '../screens/user_screens/plate_detail_screen.dart';
import '../../data/models/plate_provider_prueba.dart'; // Asegúrate de importar el modelo

class CardPlates extends StatefulWidget {
  final Plate plate;
  const CardPlates({super.key, required this.plate});

  @override
  State<CardPlates> createState() => _CardPlatesState();
}

class _CardPlatesState extends State<CardPlates> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlateDetailScreen(plate: widget.plate),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: AppColors.grayDark,
                spreadRadius: 3,
                blurRadius: 2,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  widget.plate.image, 
                  width: 120,
                  height: 120,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Text(widget.plate.name),
            ],
          ),
        ),
      ),
    );
  }
}
