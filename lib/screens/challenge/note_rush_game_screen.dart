import 'dart:async';

import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/data/models/musicKey.dart';
import 'package:FaBemol/providers/rankings.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/widgets/blurry_dialog.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:FaBemol/widgets/staves/notes_buttons_staff.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:FaBemol/functions/numbers.dart';
import 'package:provider/provider.dart';

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

  double accuracy = 0;
  double speed = 0;

  // Controle la game
  Timer timer;
  bool timerStarted = false;

  // Les résultats à aller chercher dans les providers
  bool resultsLoaded = false;
  bool isNewPB = false;
  double averageAccuracy = -1;
  double averageSpeed = -1;

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
      this.resultsLoaded = false;
      this.timerStarted = false;
      this.accuracy = (this.totalGoodAnswers / this.totalAnswers) * 100;
      this.speed = this.nbSeconds / this.totalAnswers;
    });
    saveScoreToDatabase();
  }

  Future<void> saveScoreToDatabase() async {
    // Juste pour être 100% sûr que le CircularProgress s'affiche
    setState(() {
      this.resultsLoaded = false;
    });

    UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);

    // On récupère les stats moyennes des dernières parties (ici la précision et la vitesse).
    this.averageAccuracy = userProfile.averageStat('note_rush', 'accuracy');
    this.averageSpeed = userProfile.averageStat('note_rush', 'speed');

    // On sauvegarde les nouvelles stats (ici la précision et la vitesse).
    Map<String, dynamic> newStats = {'accuracy': this.accuracy, 'speed': this.speed};
    userProfile.saveStats('note_rush', newStats);

    // On récupère le nouveau PB si besoin
    this.isNewPB = await userProfile.isNewPB(
      challengeId: 'note_rush',
      score: this.totalScore,
      category: {'key': DATA.CHALLENGE_KEYSLIST[keyIndex]['name'], 'time': DATA.CHALLENGE_TIMELIST[timeIndex]['name']},
    );


    // On sauvegarde le score une bonne fois pour toute et on check le top 10 si c'est un nouveau PB
    Provider.of<Rankings>(context, listen: false).saveScore(
      challengeId: 'note_rush',
      score: this.totalScore,
      category: {'key': DATA.CHALLENGE_KEYSLIST[keyIndex]['name'], 'time': DATA.CHALLENGE_TIMELIST[timeIndex]['name']},
      stats: newStats,
      username: userProfile.username,
      isNewPB: this.isNewPB,
    );

    setState(() {
      this.resultsLoaded = true;
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
            child: timerStarted
                ? Column(
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
                        height: 100,
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
                                    // La série de notes
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
                                    // Les bonus de combo
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
                      /// La portée et les boutons
                      /// *********************************************
                      Expanded(
                        child: ContainerFlatDesign(
                          padding: EdgeInsets.only(bottom: 5),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: Column(
                            children: [
                              // Le placeholder pour tout aligner en bas (important)
                              Expanded(child: Container()),
                              // La portée :
                              staff,
                            ],
                          ),
                        ),
                      ),

                      // La progression du temps *********************************************************************************
                      // Le progression indicator
                      LinearProgressIndicator(
                        value: (1 - (secondsLeft / nbSeconds)).toDouble(),
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                        backgroundColor: Colors.grey[200],
                      ),
                      // Le temps avec du texte
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
                  )

                // ****************************   TABLEAU DES SCORES  ********************************************************************************************************
                : ContainerFlatDesign(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    margin: EdgeInsets.all(15),
                    child: (!resultsLoaded)
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  'Chargement des résultats'.tr(),
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 15),
                                CircularProgressIndicator()
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Histoire de pas avoir de problème de scroll
                                Container(
                                  child: Column(
                                    children: [
                                      //ElevatedButton(onPressed: saveScoreToDatabase, child: Text('reload')),

                                      /// Score Total
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/icons/96/score.png', height: 30),
                                          SizedBox(width: 5),
                                          AutoSizeText('Score total', maxLines: 1, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(totalScore.toString(), maxLines: 1, style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold)),
                                          if (isNewPB) SizedBox(width: 15),
                                          if (isNewPB) Image.asset('assets/icons/96/winner.png', height: 40),
                                        ],
                                      ),
                                      if (isNewPB) Text('Nouveau record !', style: TextStyle(fontSize: 16)),
                                      SizedBox(height: 25),

                                      /// Bonnes réponses brutes
                                      AutoSizeText('Bonnes réponses', maxLines: 1, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(totalGoodAnswers.toString() + ' / ' + totalAnswers.toString(),
                                            maxLines: 1, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                                      ),

                                      SizedBox(height: 30),

                                      Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Expanded(flex: 5, child: Container()),
                                            Expanded(flex: 1, child: Container()),
                                            Expanded(flex: 2, child: AutoSizeText('Partie', maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 14))),
                                            Expanded(flex: 2, child: AutoSizeText('Récent', maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 14))),
                                          ],
                                        ),
                                      ),
                                      Divider(height: 1, thickness: 1),

                                      // LES POURCENTAGES ****************************************
                                      Container(
                                        height: 40,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: AutoSizeText('Précision', maxLines: 1, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            ),
                                            Expanded(flex: 1, child: Container()),
                                            Expanded(
                                                flex: 2,
                                                child: AutoSizeText((this.accuracy).toStringAsFixed(0) + '%',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 26,
                                                      color: (this.averageAccuracy < 0 || this.accuracy > this.averageAccuracy) ? Colors.green : Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                    ))),
                                            Expanded(
                                              flex: 2,
                                              child: Opacity(
                                                opacity: this.averageAccuracy < 0 ? 0 : 1, // On ne l'affiche pas s'il n'y a pas de moyenne
                                                child: AutoSizeText(
                                                  (this.averageAccuracy).toStringAsFixed(0) + '%',
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // LA VITESSE  ****************************************
                                      Container(
                                        height: 40,
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 5,
                                                child: Row(
                                                  children: [
                                                    AutoSizeText('Vitesse', maxLines: 1, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                    SizedBox(width: 5),
                                                    AutoSizeText('(s/notes)', maxLines: 1, style: TextStyle(fontSize: 14, color: Colors.grey)),
                                                  ],
                                                )),
                                            Expanded(flex: 1, child: Container()),
                                            Expanded(
                                                flex: 2,
                                                child: AutoSizeText((this.speed).toStringAsFixed(1),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 26,
                                                      color: (this.averageSpeed < 0 || this.speed < this.averageSpeed) ? Colors.green : Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                    ))),
                                            Expanded(
                                              flex: 2,
                                              child: Opacity(
                                                opacity: this.averageSpeed < 0 ? 0 : 1, // On ne l'affiche pas s'il n'y a pas de moyenne
                                                child: AutoSizeText(
                                                  (this.averageSpeed).toStringAsFixed(1),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  style: TextStyle(fontSize: 18, color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        height: 40,
                                        child: Row(
                                          children: [
                                            Expanded(flex: 5, child: AutoSizeText('Meilleure série', maxLines: 1, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                            Expanded(flex: 1, child: Container()),
                                            Expanded(
                                                flex: 2,
                                                child: AutoSizeText(
                                                  maxNotesInARow.toString(),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                                )),
                                            Expanded(flex: 2, child: Container()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Expanded(child: Container()),
                                Container(
                                  width: 200,
                                  margin: EdgeInsets.only(bottom: 5, top: 30),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('button_continue'.tr()),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
        // On reset le compteur
        this.notesInARow = 0;
        this.comboFactor = 1;
      });
    }
    // Si on bat le record alors on l'enregistre, sinon on garde l'ancien
    this.maxNotesInARow = (this.maxNotesInARow < this.notesInARow) ? this.notesInARow : this.maxNotesInARow;
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

/// *********************************************
/// Un widget pour les titres
/// Prend un texte en argument.
/// *********************************************
class Title extends StatelessWidget {
  final String text;

  Title({this.text});

  @override
  Widget build(BuildContext context) {
    // Un simpl Titre avec une barre en bas
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).shadowColor.withOpacity(0.2),
          ),
        ),
      ),
      child: AutoSizeText(
        text,
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        maxLines: 1,
      ),
    );
  }
}
