import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  final int? initialStars;
  final String? initialComment;
  final Function(int, String) onSave;

  const RatingDialog({Key? key, this.initialStars, this.initialComment, required this.onSave}) : super(key: key);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late int _selectedStars;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _selectedStars = widget.initialStars ?? 5;
    _commentController = TextEditingController(text: widget.initialComment);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(widget.initialStars == null ? "Calificar Restaurante" : "Editar Calificación"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => IconButton(
                icon: Icon(
                  index < _selectedStars ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _selectedStars = index + 1;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _commentController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: "Comentario",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_selectedStars, _commentController.text);
            Navigator.pop(context);
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
