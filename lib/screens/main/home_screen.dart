import 'package:FaBemol/providers/ad_manager.dart';
import 'package:FaBemol/widgets/lessonsMedias/audio_player_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:FaBemol/functions/text_format.dart';
import 'package:just_audio/just_audio.dart';
import 'package:FaBemol/functions/durations.dart';
import 'package:provider/provider.dart';
import 'package:super_rich_text/super_rich_text.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    /*Provider.of<AdManager>(context, listen: false).initAdMob();
    Provider.of<AdManager>(context, listen: false).initInterstitialAd(closedCallback: () {
      print('close');
    });*/
  }

  @override
  void dispose() {
    //Provider.of<AdManager>(context, listen: false).disposeInterstitialAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(currentTime.percentOf(totalTime));
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/logotmp2.png',
            width: double.infinity,
          ),
          Divider(height: 1),
          SizedBox(height: 20),
          SuperRichText(
            text: "Bonne chance! :trefle:".addSmiley(),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16, fontFamily: 'Roboto'),
            othersMarkers: markersList,
          ),
          Divider(),
          /*ElevatedButton(
              onPressed: () {
                Provider.of<AdManager>(context, listen: false).showInterstitialAd();
              },
              child: Text('Envoyer')),*/
          AudioPlayerWidget(
            media: {
              'type': 'audioPlayer',
              'src': 'https://firebasestorage.googleapis.com/v0/b/fabemol-29366.appspot.com/o/lessons%2Fmusics%2Fbeethoven_sonata_14_mvt1_extract.mp3?alt=media&token=723de15d-bdc8-400f-a17c-c8ba6440be00',
            },
          ),
        ],
      ),
    );
  }
}
