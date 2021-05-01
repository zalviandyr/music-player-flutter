import 'package:flutter/material.dart';
import 'package:music_player/config/pallette.dart';
import 'package:music_player/models/models.dart';

class PlaylistItem extends StatelessWidget {
  final Function() onTap;
  final Playlist playlist;

  const PlaylistItem({required this.onTap, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: Pallette.listItemColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        playlist.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20.0,
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  '${playlist.countMusic} musics',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
