import 'package:FaBemol/data/data.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:FaBemol/widgets/appbars/widgets/lives_counter_widget.dart';
import 'package:flutter/material.dart';

import 'package:FaBemol/functions/localization.dart';

class ChallengeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String challengeId;

  const ChallengeAppBar({
    Key key,
    this.height = 45,
    this.challengeId = 'none',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final color = Theme.of(context).shadowColor;

    return SafeArea(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: color),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        padding: EdgeInsets.only(left: 5, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            // Si on doit afficher un nom de challenge
            if(challengeId != 'none')
              Expanded(child: ChallengeName(challengeId)),
            // Sinon on met un blanc
            if(challengeId == 'none')
              Expanded(child: SizedBox()),


            // Les coeurs
            LivesCounterWidget(),

          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}



/// *********************************************
/// S'affiche si on est dans une catégorie
/// *********************************************
class ChallengeName extends StatelessWidget {
  final String challengeId;
  ChallengeName(this.challengeId);

  @override
  Widget build(BuildContext context) {

    final challenge = DATA.CHALLENGES_CATEGORIES[challengeId];

    return Row(
      children: [
        // Une flèche pour back
        InkWell(child: Icon(Icons.arrow_back), onTap: (){Navigator.of(context).pop();},),
        SizedBox(width: 5,),
        Hero(tag : 'icon_$challengeId', child: Image.asset(challenge['icon'].toString())),
        SizedBox(width: 5,),
        Expanded(child: Hero(tag : 'title_$challengeId', child: AutoSizeText(challenge['title'].toString().tr(), style: Theme.of(context).textTheme.headline6,maxLines: 1,))),
      ],
    );
  }
}




