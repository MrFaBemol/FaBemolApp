import 'dart:async';

import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/widgets/challenge/rankings_score_tile.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class NoteRushScoresSwiper extends StatefulWidget {
  @override
  _NoteRushScoresSwiperState createState() => _NoteRushScoresSwiperState();
}

class _NoteRushScoresSwiperState extends State<NoteRushScoresSwiper> {

  // La liste des podiums qui sera affichées dans le swiper
  List<Widget> keysPodiumList = [];
  String time = '1min';

  // Controle le défilement
  Timer timer;
  int index = 0;
  Widget displayedPodium ;

  @override
  void initState() {
    super.initState();

    // La liste des podiums qu'on génère ici
    DATA.NOTE_RUSH_KEYSLIST.forEach((key) {
      keysPodiumList.add(
          Column(
            key: ValueKey(DATA.NOTE_RUSH_KEYSLIST.indexOf(key)),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Le titre
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: AutoSizeText(
                  ('challenge_key_'+key['name']).tr() + ' - ' + time,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),

              // Le podium
              RankingsScoreTile(challengeId: 'note_rush', rank: 1, category: {'key': key['name'], 'time': time}),
              RankingsScoreTile(challengeId: 'note_rush', rank: 2, category: {'key': key['name'], 'time': time}),
              RankingsScoreTile(challengeId: 'note_rush', rank: 3, category: {'key': key['name'], 'time': time}),
            ],
          )
      );
    });

    // On set le premier podium qu'on affiche
    this.displayedPodium =  keysPodiumList[this.index];
    // Puis on crée un timer qui va boucler entre les podiums toutes les 3 secondes
    this.timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        this.index++;
        // Si on dépasse les limites du tableau, on revient à 0
        if (this.index == keysPodiumList.length) this.index = 0;
        // On change ce qu'on affiche
        this.displayedPodium = keysPodiumList[this.index];
      });
    });
  }


  @override
  void dispose() {
    if (this.timer != null && this.timer.isActive) {
      this.timer.cancel();
    }
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return AnimatedSwitcher(duration: Duration(milliseconds: 800), child: displayedPodium,);
  }
}
