import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/data/models/musicKey.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/screens/challenge/note_rush_game_screen.dart';
import 'package:FaBemol/widgets/appbars/challenge_appbar.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:FaBemol/widgets/item_life_cost_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteRushChoiceScreen extends StatefulWidget {
  static const String routeName = '/note-rush-choice';

  @override
  _NoteRushChoiceScreenState createState() => _NoteRushChoiceScreenState();
}

class _NoteRushChoiceScreenState extends State<NoteRushChoiceScreen> {
  int keyChoice = -1;
  int timeChoice = -1;
  bool isLoading = false;

  /// *********************************************
  /// Les setters de la clé et du temps.
  /// On passe l'index en argument plutôt que les données brutes (plus facile pour ensuite l'utiliser dans le screen du jeu)
  /// *********************************************
  void _setKeyChoice(int index) {
    setState(() {
      this.keyChoice = index;
    });
  }

  void _setTimeChoice(int index) {
    setState(() {
      this.timeChoice = index;
    });
  }

  /// *********************************************
  /// La fonction qui charge le jeu et change de screen (enlève les vies)
  /// *********************************************
  void startGame(int lifeCost, String challengeId) async {
    setState(() {
      isLoading = true;
    });

    try {
      // On utilise le nombre de vies
      await Provider.of<UserProfile>(context, listen: false).useLives(lifeCost);
      // On s'envole vers la nouvelle page.
      Navigator.of(context).pushNamed(NoteRushGameScreen.routeName, arguments: {'keyIndex': this.keyChoice, 'timeIndex': this.timeChoice, 'challengeId': challengeId});
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Les infos pour l'app bar (titre et icone)
    final challengeId = ModalRoute.of(context).settings.arguments as String;

    // On génère les cards des clés
    List<Widget> keysChoices = [];
    for (int i = 0; i < DATA.CHALLENGE_KEYSLIST.length; i++) {
      keysChoices.add(KeyChoiceCard(
        index: i,
        callback: () {
          _setKeyChoice(i);
        },
        isSelected: i == this.keyChoice,
      ));
    }

    //int keyPerLine = 2;

    // On génère les cards des times
    List<Widget> timesChoices = [];
    for (int i = 0; i < DATA.CHALLENGE_TIMELIST.length; i++) {
      timesChoices.add(TimeChoiceCard(
        index: i,
        callback: () {
          _setTimeChoice(i);
        },
        isSelected: i == this.timeChoice,
      ));
    }

    // On check si le mec peut lancer la partie (1 vie)
    int lifeCost = 1;
    final bool hasEnoughLives = Provider.of<UserProfile>(context, listen: false).hasEnoughLives(lifeCost);

    // La page
    return Scaffold(
      appBar: ChallengeAppBar(
        challengeId: challengeId,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  // Le choix de la clé
                  ContainerFlatDesign(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Column(
                      children: [
                        ChoiceTitle(text: 'key_choice'.tr() + ' '),
                        Row(children: keysChoices),
                        SizedBox(height: 10),
                        ChoiceTitle(text: 'time_choice'.tr() + ' '),
                        Row(children: timesChoices),
                        SizedBox(height: 30),

                        // Le coût en vie
                        LifeCostText(lifeCost),

                        //************************** Le bouton pour se lancer
                        if (hasEnoughLives)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                            width: double.infinity,
                            child: ElevatedButton(
                              //@todo: créer un provider pour les challenges et gérer les données dedans
                              onPressed: (this.keyChoice < 0 || this.timeChoice < 0)
                                  ? null
                                  : () {
                                      // Lance le jeu
                                      startGame(lifeCost, challengeId);
                                    },
                              child: Text(
                                'button_lets_go'.tr(),
                              ),
                            ),
                          ),

                        if (!hasEnoughLives)
                          Container(
                            width: 200,
                            margin: EdgeInsets.all(5),
                            child: AutoSizeText(
                              'error_not_enough_lives'.tr(),
                              style: TextStyle(color: Theme.of(context).errorColor, fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// *********************************************
/// Un widget pour les titres
/// Prend un texte en argument.
/// *********************************************
class ChoiceTitle extends StatelessWidget {
  final String text;

  ChoiceTitle({this.text});

  @override
  Widget build(BuildContext context) {
    // Un simpl Titre avec une barre en bas
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).shadowColor.withOpacity(0.5),
          ),
        ),
      ),
      child: AutoSizeText(
        text,
        style: Theme.of(context).textTheme.headline6,
        maxLines: 1,
      ),
    );
  }
}

/// *********************************************
///   Permet de créer les cartes pour les clefs
/// *********************************************
class KeyChoiceCard extends StatelessWidget {
  final int index;
  final Function callback;
  final bool isSelected;

  KeyChoiceCard({this.index, this.callback, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    // la keyMap pour les infos (l'icone)
    Map<String, dynamic> keyMap = DATA.CHALLENGE_KEYSLIST[index];

    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: callback,
        child: Container(
          height: 120,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isSelected) ? Theme.of(context).shadowColor.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (isSelected) ? Theme.of(context).shadowColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: MusicKey(keyType: keyMap['type'], line: keyMap['line']).renderAlone(),
        ),
      ),
    );
  }
}

/// *********************************************
/// Permet de créer les cartes pour les timer
/// *********************************************
class TimeChoiceCard extends StatelessWidget {
  final int index;
  final Function callback;
  final bool isSelected;

  TimeChoiceCard({this.index, this.callback, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> timeMap = DATA.CHALLENGE_TIMELIST[index];

    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: callback,
        child: Container(
          height: 110,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: (isSelected) ? Theme.of(context).shadowColor.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (isSelected) ? Theme.of(context).shadowColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Expanded(child: Image.asset('assets/icons/96/' + timeMap['icon'])),
              AutoSizeText(
                timeMap['name'].toString().tr(),
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
