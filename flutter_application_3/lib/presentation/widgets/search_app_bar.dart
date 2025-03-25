import 'package:flutter/material.dart';
import 'package:flutter_application_example/core/constants/main_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onSearchPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBackground, // Color rojo
      centerTitle: true,
      elevation: 0,
      title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: onSearchPressed, // Navega a la pantalla de búsqueda al tocar
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.menu, color: Colors.black54),
                  ),
                  const Expanded(
                    child: Text(
                      "Search",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black54),
                    onPressed: onSearchPressed,
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.black54),
                    onPressed: () {
                      // Acción de notificaciones
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
