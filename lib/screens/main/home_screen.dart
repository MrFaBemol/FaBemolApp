
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  AudioPlayer player;

  playNote() async {
    this.player.play().then((value) {
      this.player.pause();
      this.player.seek(Duration.zero);
    });
  }

  @override
  void initState() {
    super.initState();
    this.player = new AudioPlayer();
    loadFiles();
  }


  void loadFiles() async{
    var duration = await this.player.setAsset('assets/sounds/notes/piano/A4.mp3');
    print(duration);
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/logotmp2.png',
            width: double.infinity,
          ),
          Divider(height: 1),
          SizedBox(height: 20),
          Text(
            'On va bien trouver quelque chose à afficher par ici ',
            textAlign: TextAlign.justify,
          ),
          ElevatedButton(
            onPressed: playNote,
            child: Text('jouer le son'),
          ),
        ],
      ),
    );
  }
}
