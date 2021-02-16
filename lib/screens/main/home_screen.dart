
import 'package:flutter/material.dart';

import 'package:FaBemol/functions/text_format.dart';
import 'package:super_rich_text/super_rich_text.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


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
          SuperRichText(
            text: "*Félicitations !* :D \n\nPourquoi ? Oh et bien... Si nous nous rencontrons, je suppose que c'est parce que tu as décidé d'apprendre la musique! \n\nEst-ce parce que tu as entendu un morceau qui te plaisait? Je serais curieux de le connaitre! Si le coeur t'en dit, tu peux écouter celui qui m'a donné le goût de la musique en cliquant sur le bouton au dessus!".addSmiley(),

            //currentStepText.addSmiley(),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16, fontFamily: 'Roboto'),
          ),
          Divider(),
          Text(
            "*Félicitations !* :D \n\nPourquoi ? Oh et bien... Si nous nous rencontrons, je suppose que c'est parce que tu as décidé d'apprendre la musique! \n\nEst-ce parce que tu as entendu un morceau qui te plaisait? Je serais curieux de le connaitre! Si le coeur t'en dit, tu peux écouter celui qui m'a donné le goût de la musique en cliquant sur le bouton au dessus!".addSmiley(),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
          ),
        ],
      ),
    );
  }
}
