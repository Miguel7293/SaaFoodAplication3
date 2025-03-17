import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/main_colors.dart';

class CardPlates extends StatefulWidget {
  final String image;
  final String name;

  const CardPlates({super.key, required this.image, required this.name});

  @override
  State<CardPlates> createState() => _CardPlatesState();
}

class _CardPlatesState extends State<CardPlates> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: AppColors.grayDark,
              spreadRadius: 3,
              blurRadius: 2,
              offset: Offset(0, 3)
            )
          ]
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(widget.image,
                width: 120, height: 120, fit: BoxFit.fitHeight),
          ),
          Text(widget.name)
        ]),
      ),
    );
  }
}
