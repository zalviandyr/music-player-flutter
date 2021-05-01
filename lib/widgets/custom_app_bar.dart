import 'package:flutter/material.dart';
import 'package:music_player/config/pallette.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;

  const CustomAppBar({required this.label});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          label,
          style: const TextStyle(
            letterSpacing: 1.2,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0.0,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Pallette.listItemColor,
                size: 30.0,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
