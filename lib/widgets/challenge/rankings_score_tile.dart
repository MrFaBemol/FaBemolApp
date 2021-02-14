
import 'package:FaBemol/providers/rankings.dart';
import 'package:FaBemol/screens/social/any_user_profile_page_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// *********************************************
/// Affiche un score avec la médaille et le nom
/// *********************************************
class RankingsScoreTile extends StatelessWidget {
  final int rank;
  final String challengeId;
  final dynamic category;

  RankingsScoreTile({this.challengeId, this.rank = 1, this.category});

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