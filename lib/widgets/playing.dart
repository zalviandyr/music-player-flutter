import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/widgets/widgets.dart';

class Playing extends StatelessWidget {
  final String title;
  final Function() onPlayPause;
  final Function() onPrev;
  final Function() onNext;
  final Function() onShuffle;
  final bool isPlaying;

  const Playing({
    required this.title,
    required this.onPlayPause,
    required this.onPrev,
    required this.onNext,
    required this.onShuffle,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 25,
              child: Marquee(
                text: title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  letterSpacing: 1.5,
                ),
                velocity: 40.0,
                blankSpace: 100.0,
                fadingEdgeEndFraction: 0.2,
                fadingEdgeStartFraction: 0.2,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.shuffle),
                  onPressed: onShuffle,
                ),
                CustomButton(
                  icon: Icons.skip_previous,
                  onPressed: onPrev,
                  gradient: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor,
                  ],
                ),
                CustomButton(
                  icon: isPlaying ? Icons.pause : Icons.play_arrow,
                  onPressed: onPlayPause,
                  gradient: isPlaying
                      ? [
                          Color(0xFFd26403),
                          Colors.yellow,
                        ]
                      : [
                          Theme.of(context).primaryColor,
                          Theme.of(context).accentColor,
                        ],
                ),
                CustomButton(
                  icon: Icons.skip_next,
                  onPressed: onNext,
                  gradient: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor,
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.queue_music),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
