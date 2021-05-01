import 'package:flutter/material.dart';
import 'package:music_player/config/pallette.dart';
import 'package:music_player/widgets/widgets.dart';

class SongItem extends StatelessWidget {
  final String title;
  final Function() onTap;

  const SongItem({required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: Pallette.listItemColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            padding: const EdgeInsets.only(
                top: 15.0, bottom: 15.0, right: 10.0, left: 5.0),
            child: Row(
              children: [
                CustomButton(
                  icon: Icons.play_arrow,
                  onPressed: onTap,
                  gradient: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor,
                  ],
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 1.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
