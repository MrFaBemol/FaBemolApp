import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:FaBemol/functions/durations.dart';

class AudioPlayerWidget extends StatefulWidget {
  final dynamic media;

  AudioPlayerWidget({this.media});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  AudioPlayer player;
  Duration currentTime;
  Duration totalTime;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    currentTime = Duration.zero;
    totalTime = Duration.zero;
    load();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  /// *********************************************
  /// Charge le fichier en mémoire et récupère la durée, puis met à jour le state
  /// *********************************************
  void load() async {
    totalTime = await player.setUrl(widget.media['url']);
    setState(() {});
  }

  /// *********************************************
  /// Lance le fichier audio et écoute l'avancement avec un stream
  /// *********************************************
  play() {
    player.play();
    player.positionStream.listen((time) {
      setState(() {
        this.currentTime = time;
      });
    });
    setState(() {});
  }

  /// *********************************************
  /// Fonctions pour pause / stop
  /// *********************************************
  pause() {
    player.pause();
    setState(() {});
  }

  stop() {
    pause();
    player.seek(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          InkWell(
            splashColor: Colors.transparent,
            onTap: player.playing ? pause : play,
            child: Container(
              height: 200,
              child: player.playing
                  ? Image.asset(
                      'assets/icons/240/audio_pause.png',
                      color: Theme.of(context).accentColor,
                    )
                  : Image.asset(
                      'assets/icons/240/audio_lecture.png',
                      color: Theme.of(context).accentColor,
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(currentTime.toStringMS() + ' / ' + totalTime.toStringMS()),
            ],
          ),
          Slider(
            value: currentTime.percentOf(totalTime),
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Colors.grey[200],
            onChanged: (value) {
              //print(value);
              setState(() {
                this.currentTime = Duration(microseconds: this.totalTime.inMicroseconds ~/ (1 / value));
                this.player.seek(this.currentTime);
                //print(this.currentTime);
              });
            },
            min: 0,
            max: 1,
            divisions: 500,
          ),
        ],
      ),
    );
  }
}
