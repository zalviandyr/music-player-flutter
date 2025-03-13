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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary,
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
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
              MaterialButton(
                child: Icon(Icons.shuffle),
                onPressed: onShuffle,
                padding: const EdgeInsets.all(10.0),
                shape: CircleBorder(),
              ),
              CustomButton(
                icon: Icons.skip_previous,
                onPressed: onPrev,
                gradient: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
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
                        Theme.of(context).colorScheme.secondary,
                      ],
              ),
              CustomButton(
                icon: Icons.skip_next,
                onPressed: onNext,
                gradient: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              MaterialButton(
                child: Icon(Icons.queue_music),
                onPressed: () {},
                padding: const EdgeInsets.all(10.0),
                shape: CircleBorder(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
