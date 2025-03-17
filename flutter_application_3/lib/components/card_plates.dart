import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/main_colors.dart';
import 'package:flutter_application_example/screens/user_screens/plate_detail_screen.dart';
import 'package:flutter_application_example/data/plate_provider_prueba.dart'; // Asegúrate de importar el modelo

class CardPlates extends StatefulWidget {
  final Plate plate; // Cambiamos a Plate en vez de String image y String name

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
                  widget.plate.image, // Ahora usa el objeto Plate
                  width: 120,
                  height: 120,
                  fit: BoxFit.fitHeight,
                ),
              ),
              Text(widget.plate.name), // También usa el objeto Plate
            ],
          ),
        ),
      ),
    );
  }
}
