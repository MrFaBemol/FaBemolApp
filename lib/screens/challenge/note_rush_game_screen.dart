import 'dart:async';

import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/data/models/musicKey.dart';
import 'package:FaBemol/widgets/blurry_dialog.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:FaBemol/widgets/staves/notes_buttons_staff.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:FaBemol/functions/numbers.dart';

class NoteRushGameScreen extends StatefulWidget {
  static const String routeName = '/note-rush-game';

  @override
  _NoteRushGameScreenState createState() => _NoteRushGameScreenState();
}

class _NoteRushGameScreenState extends State<NoteRushGameScreen> {
  // Toutes les infos
  String layout = 'circle';
  String challengeId = '';

  // Les infos a récupérer en argument.
  int keyIndex = -1;
  int timeIndex = -1;
  bool isLoaded = false;

  // Les stats de base
  int nbSeconds, secondsLeft = 0;
  int nbNotes = 3;

  // Les scores / stats
  int totalScore = 0;
  int totalAnswers = 0;
  int totalGoodAnswers = 0;
  int comboFactor = 1;

  int notesInARow = 0;
  int maxNotesInARow = 0;

  double goodAnswersPercentage = 0;
  double notesPerSecond = 0;

  Timer timer;
  bool timerStarted = false;

  @override
  void dispose() {
    // De quoi annuler le timer quand on quitte la page
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  void initGame() {
    // On démarre le timer
    this.timerStarted = true;
    //@todo: créer un provider pour chaque challenge et gérer les données dedans
    final args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    setState(() {
      this.keyIndex = args['keyIndex'];
      this.timeIndex = args['timeIndex'];
      this.challengeId = args['challengeId'];
      this.isLoaded = true;
      this.nbSeconds = DATA.CHALLENGE_TIMELIST[timeIndex]['time'];
      this.secondsLeft = this.nbSeconds;
    });
  }

  void endGame() {
    this.timer.cancel();
    setState(() {
      this.timerStarted = false;
      this.goodAnswersPercentage = (this.totalGoodAnswers / this.totalAnswers) * 100;
      this.notesPerSecond = this.totalAnswers / this.nbSeconds;
    });
  }

  /// *********************************************
  /// Le Build
  /// *********************************************
  @override
  Widget build(BuildContext context) {
    // Si on a pas fait le chargement :
    if (!isLoaded) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // On crée la bonne portée avec la bonne clé**************************************
    NotesButtonsStaff staff = NotesButtonsStaff(
      // On envoie directement un objet ça évite trop d'arguments
      musicKey: MusicKey(
        keyType: DATA.CHALLENGE_KEYSLIST[keyIndex]['type'],
        line: DATA.CHALLENGE_KEYSLIST[keyIndex]['line'],
      ),
      notesQuantity: this.nbNotes,
      onFinish: finishStaff,
      onClick: getAnswer,
      layout: layout,
    );

    // Calcul du temps restant :
    String formattedTime = secondsLeft.toStringTimeFormatted(showHours: false, clockFormat: true);

    return WillPopScope(
      onWillPop: _askConfirmationToQuit,
      child: Scaffold(
        body: SafeArea(
          //  Container qui prend tout l'écran
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                /// *********************************************
                /// La barre d'état
                /// *********************************************
                Header(challengeId, _askConfirmationToQuit),

                /// *********************************************
                /// Les infos
                /// *********************************************
                Container(
                  //padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  height: 120,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      // *********************   LE SCORE
                      Expanded(
                        flex: 1,
                        child: ContainerFlatDesign(
                          borderRadius: BorderRadius.circular(10),
                          margin: EdgeInsets.only(right: 5),
                          child: Column(
                            children: [
                              // L'icone et le texte
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/icons/96/score.png', height: 30),
                                  SizedBox(width: 5),
                                  AutoSizeText('Score', style: Theme.of(context).textTheme.headline6, maxLines: 1),
                                ],
                              ),
                              // Le score
                              AutoSizeText(totalScore.toString(), style: Theme.of(context).textTheme.headline4, maxLines: 1),
                            ],
                          ),
                        ),
                      ),
                      // Les stats pendant le jeu :
                      Expanded(
                        flex: 1,
                        child: ContainerFlatDesign(
                          borderRadius: BorderRadius.circular(10),
                          padding: EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 5),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/icons/96/croches.png', height: 30),
                                    SizedBox(width: 5),
                                    AutoSizeText('Série ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22), maxLines: 1),
                                    Expanded(child: Container()),
                                    AutoSizeText(this.notesInARow.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22), maxLines: 1),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/icons/96/trefle.png', height: 30),
                                    SizedBox(width: 5),
                                    AutoSizeText('Combo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22), maxLines: 1),
                                    Expanded(child: Container()),
                                    AutoSizeText('x' + this.comboFactor.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22), maxLines: 1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// *********************************************
                /// La portée
                /// *********************************************
                Expanded(
                  child: ContainerFlatDesign(
                    padding: EdgeInsets.only(bottom: 20),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Le placeholder pour tout aligner en bas (important)
                        Expanded(child: Container()),

                        // Si le jeu est en cours :
                        if (timerStarted) staff,

                        // Si le jeu est terminé :
                        if (!timerStarted)
                          Container(
                            child: Column(
                              children: [
                                AutoSizeText('Bonnes réponses : $totalGoodAnswers', maxLines: 1),
                                AutoSizeText('Pourcentage de bonnes réponses : ' + (this.goodAnswersPercentage).toStringAsFixed(0) + '%', maxLines: 1),
                                AutoSizeText('Vitesse de réponse : ' + (this.notesPerSecond).toStringAsFixed(2) + 'notes/s', maxLines: 1),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('button_back'.tr()),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),

                // La progression du temps *********************************************************************************
                LinearProgressIndicator(
                  value: (1 - (secondsLeft / nbSeconds)).toDouble(),
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                  backgroundColor: Colors.grey[200],
                ),
                Container(
                  height: 45,
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Theme.of(context).backgroundColor,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: AutoSizeText(
                    formattedTime,
                    style: Theme.of(context).textTheme.headline6,
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// *********************************************
  /// FIN DU BUILD
  /// *********************************************

  /// *******************************************************************************************************************************************
  /// Gère le combo et cie
  /// *********************************************
  void getAnswer(bool isCorrect) {
    this.totalAnswers++;
    if (isCorrect) {
      setState(() {
        // On augmente la série et ajoute 1 au combo si on a passé une dizaine
        this.totalGoodAnswers++;
        this.notesInARow++;
        this.comboFactor += (notesInARow % 10 == 0) ? 1 : 0;
        addPoints(1);
      });
    } else {
      setState(() {
        // Si on bat le record alors on l'enregistre, sinon on garde l'ancien
        this.maxNotesInARow = (this.maxNotesInARow < this.notesInARow) ? this.notesInARow : this.maxNotesInARow;
        // Puis on reset le compteur
        this.notesInARow = 0;
        this.comboFactor = 1;
      });
    }
  }

  /// *********************************************
  /// Ce qui se lance quand on finit un staff (augmentation de la difficulté ?)
  /// *********************************************
  void finishStaff(int nbGoodAnswers) {
    setState(() {
      // On ajoute une note s'il y en a moins que 8
      this.nbNotes += this.nbNotes < 8 ? 1 : 0;
      addPoints(nbGoodAnswers);
    });
  }

  /// *********************************************
  /// Ajoute les points comme il faut.
  /// *********************************************
  void addPoints(int nbPoint) {
    setState(() {
      // On ajoute le nombre de point multiplié par le combo
      this.totalScore += nbPoint * this.comboFactor;
    });
  }

  /// *********************************************
  /// Ce qui charge le timer et cie
  /// *********************************************
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Si le timer n'est pas lancé, c'est parti !
    if (!timerStarted && !isLoaded && mounted) {
      // On démarre le jeu
      initGame();
      this.timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          this.secondsLeft--;
          // Si le temps est écoulé, on termine le jeu
          if (this.secondsLeft == 0) {
            endGame();
          }
        });
      });
    }
  }

  /// *********************************************
  /// Si besoin de se barrer de la leçon (annule tout sans sauvegarder)
  /// *********************************************
  void quitGame() {
    Navigator.of(context).pop();
  }

  Future<bool> _askConfirmationToQuit() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BlurryDialog(
            title: 'warning'.tr(),
            content: 'ask_quit_challenge'.tr(),
            buttonOk: 'yes'.tr(),
            buttonCancel: 'no'.tr(),
            continueCallBack: () {
              quitGame();
              Navigator.of(context).pop();
            },
          );
        });
  }
}

/// *********************************************
/// La barre d'état du jeu
/// *********************************************
class Header extends StatelessWidget {
  final Function askConfirmationToQuit;
  final String challengeId;

  Header(this.challengeId, this.askConfirmationToQuit);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5, color: Theme.of(context).shadowColor),
        ),
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Le bouton pour quitter la leçon
          IconButton(
            icon: Icon(Icons.clear),
            color: Theme.of(context).accentColor,
            onPressed: askConfirmationToQuit,
          ),
          // Le titre
          Expanded(
            child: Hero(
              tag: 'title_' + challengeId,
              child: AutoSizeText(
                DATA.CHALLENGES_CATEGORIES[challengeId]['title'].toString().tr(),
                style: Theme.of(context).textTheme.headline6,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // L'icone
          Hero(
            tag: 'icon_' + challengeId,
            child: Image.asset(DATA.CHALLENGES_CATEGORIES[challengeId]['icon'].toString()),
          ),
          SizedBox(width: 5),
        ],
      ),
    );
  }
}
