import 'package:FaBemol/providers/rankings.dart';
import 'package:FaBemol/screens/social/any_user_profile_page_screen.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:FaBemol/widgets/large_elevated_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeCategoryCard extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final String challengeId;

  ChallengeCategoryCard(this.challengeId, this.challenge);

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
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Le titre et le podium
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: AutoSizeText(
                        'challenge_key_G2'.tr(),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    RankingScoreTile(challengeId: this.challengeId, rank: 1, category: {'key': 'G2', 'time': '30s'}),
                    RankingScoreTile(challengeId: this.challengeId, rank: 2, category: {'key': 'G2', 'time': '30s'}),
                    RankingScoreTile(challengeId: this.challengeId, rank: 3, category: {'key': 'G2', 'time': '30s'}),
                  ],
                ),
              ),

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
          )
        ],
      ),
    );
  }
}

/// *********************************************
/// Affiche un score avec la médaille et le nom
/// *********************************************
class RankingScoreTile extends StatelessWidget {
  final int rank;
  final String challengeId;
  final dynamic category;

  RankingScoreTile({this.challengeId, this.rank = 1, this.category});

  @override
  Widget build(BuildContext context) {
    // On récupère les infos du rang depuis le service
    var user = Provider.of<Rankings>(context).getRankedUser(challengeId: this.challengeId, rank: this.rank, category: this.category);

    // On retourne le Widget
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/icons/96/medaille$rank.png', width: 24),
        SizedBox(width: 5),
        InkWell(
          // On met un event onTap uniquement s'il y a un utilisateur à afficher, et si ce n'est pas l'utilisateur actif (impossible de cliquer sur son propre nom)
          onTap: user == null ||user['userId'] == FirebaseAuth.instance.currentUser.uid
              ? null
              : () {
                  Navigator.of(context).pushNamed(AnyUserProfilePageScreen.routeName, arguments: {'userId': user['userId']});
                },
          child: AutoSizeText(
            user != null ? user['username'] : '---',
            maxLines: 1,
          ),
        ),
        Expanded(child: Container()),
        AutoSizeText(
          user != null ? user['score'].toString() : '-',
          maxLines: 1,
        ),
      ],
    );
  }
}
