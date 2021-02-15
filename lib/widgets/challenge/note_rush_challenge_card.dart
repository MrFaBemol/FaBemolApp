import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/widgets/challenge/note_rush_scores_swiper.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:FaBemol/widgets/large_elevated_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:flutter/material.dart';

class NoteRushChallengeCard extends StatelessWidget {
  final Map<String, dynamic> challenge = DATA.CHALLENGES_CATEGORIES['note_rush'];
  final String challengeId = 'note_rush';

  NoteRushChallengeCard();

  @override
  Widget build(BuildContext context) {
    // La card principale
    return ContainerFlatDesign(
      // Les marges pour pas tout coller
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      borderRadius: BorderRadius.circular(10),
      borderWidth: 1.5,

      // Le contenu entier
      child: Column(
        children: [
          // L'icône et le titre
          Row(
            children: [
              Hero(
                tag: 'icon_$challengeId',
                child: Image.asset(
                  challenge['icon'],
                  height: 60,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Hero(
                    tag: 'title_$challengeId',
                    child: AutoSizeText(
                      challenge['title'].toString().tr(),
                      style: Theme.of(context).textTheme.headline4.copyWith(color: Theme.of(context).primaryColor),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Row(
            children: [
              //Image.asset('assets/images/staff/keys/G.png', height: 70,),
              // *********************** Les scores qui défilent
              Expanded(flex: 2, child: NoteRushScoresSwiper()),

              // **********************  Le bouton Jouer
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: LargeElevatedButton(
                    height: 90,
                    onPressed: () {
                      // On envoie la nouvelle page avec la catégorie en argument (principalement pour l'icone et le titre)
                      Navigator.of(context).pushNamed(challenge['path'], arguments: this.challengeId);
                    },
                    text: 'button_play'.tr(),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
