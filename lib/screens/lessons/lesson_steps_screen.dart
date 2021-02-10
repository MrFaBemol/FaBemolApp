import 'package:FaBemol/providers/lesson.dart';
import 'package:FaBemol/screens/lessons/lesson_complete_screen.dart';
import 'package:FaBemol/widgets/blurry_dialog.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:provider/provider.dart';

class LessonStepsScreen extends StatefulWidget {
  static const String routeName = '/lessons-steps';

  @override
  _LessonStepsScreenState createState() => _LessonStepsScreenState();
}

class _LessonStepsScreenState extends State<LessonStepsScreen> {
  // On initialise le step au tout début
  int currentStep;

  @override
  void initState() {
    currentStep = 1; // On initialise à 1 exceptionnellement
    super.initState();
  }

  // Si besoin de se barrer de la leçon (annule tout sans sauvegarder)
  void quitLesson() {
    Navigator.of(context).pop();
  }

  Future<bool> _askConfirmationToQuit() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BlurryDialog(
            title: 'warning'.tr(),
            content: 'ask_quit_lesson'.tr(),
            buttonOk: 'yes'.tr(),
            buttonCancel: 'no'.tr(),
            continueCallBack: () {
              quitLesson();
              Navigator.of(context).pop();
            },
          );
        });
  }

  // Si on termine la leçon
  void finishLesson(Lesson lessonProvider) {
    // On valide le callback, c'est important
    if (lessonProvider.nextStep()) {
      Navigator.of(context).popAndPushNamed(LessonCompleteScreen.routeName);
    }
  }

  // Les fonctions qui permettent de naviguer
  void nextStep(Lesson lessonProvider) {
    // Si on a le droit d'avancer
    if (lessonProvider.nextStep()) {
      setState(() {
        currentStep += 1;
      });
    }
  }

  void previousStep(Lesson lessonProvider) {
    // On réinitialise les fonctions de callback avant de repartir en arrière
    lessonProvider.previousStep();
    setState(() {
      currentStep -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // On a besoin de la key pour y accéder dans le provider (pour afficher les snackbar par exemple)
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    // On init le provider et on set la key du scaffold
    var lessonProvider = Provider.of<Lesson>(context, listen: false);
    lessonProvider.setKey(_scaffoldKey);
    lessonProvider.setContext(context);

    // Le nombre d'étapes de la leçon et le pourcentage de la progression
    int numberOfSteps = lessonProvider.numberOfSteps;
    double progressionPercentage =
        currentStep.toDouble() / numberOfSteps.toDouble();

    // On récupère le contenu à afficher
    String currentStepText = lessonProvider.getStepText(currentStep);
    Widget currentStepDisplay = lessonProvider.getStepDisplay(currentStep);
    Map<String, String> currentStepAudio =
        lessonProvider.getStepAudio(currentStep);

    // Et on définit les actions des flèches
    Function leftArrowAction =
        currentStep > 1 ? () => previousStep(lessonProvider) : null;
    Function rightArrowAction = currentStep < numberOfSteps
        ? () => nextStep(lessonProvider)
        : () => finishLesson(lessonProvider);

    return WillPopScope(
      onWillPop: _askConfirmationToQuit,
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //color: Colors.blue[100],
            child: Column(
              children: [
                // La barre du haut *********************************************************************************
                Container(
                    height: 40,
                    width: double.infinity,
                    color: Theme.of(context).backgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Le bouton pour quitter la leçon
                        IconButton(
                          icon: Icon(Icons.clear),
                          color: Theme.of(context).accentColor,
                          onPressed: _askConfirmationToQuit,
                        ),
                        // Le titre
                        Expanded(
                          child: Hero(
                            tag: 'title_' + lessonProvider.lessonId,
                            child: AutoSizeText(
                              lessonProvider.title,
                              style: Theme.of(context).textTheme.headline6,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // L'icone
                        Hero(
                          tag: 'icon_' + lessonProvider.lessonId,
                          child: Image.network(lessonProvider.icon),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),

                // Le display   ****************************************************************************
                Expanded(
                  flex: 6,
                  // Un container flat design qui rox
                  child: ContainerFlatDesign(
                    padding: EdgeInsets.only(bottom: 0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: currentStepDisplay,
                  ),
                ),

                // L'audio *********************************************************************************
                if (currentStepAudio != null) AudioPlayer(),

                // Le texte principal // L'audio ***********************************************************
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),

                    //@todo : IMPORTANT remonter le SCSV quand on change de page
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        'Je me répète mais :\n ' +
                            ((currentStepText + '\n') * 10),
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                // La navigation *********************************************************************************
                LinearProgressIndicator(
                  value: progressionPercentage,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor),
                  backgroundColor: Colors.grey[200],
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  color: Theme.of(context).backgroundColor,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Les widgets des flèches avec leurs directions
                      ChangeStepArrow(
                        arrowAction: leftArrowAction,
                        direction: ChangeStepArrow.left,
                      ),
                      Text('$currentStep / $numberOfSteps'),
                      ChangeStepArrow(
                        arrowAction: rightArrowAction,
                        direction: ChangeStepArrow.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// *********************************************
/// Génère un player audio avec les infos passées en paramètres
/// @todo: à faire !
/// *********************************************
class AudioPlayer extends StatefulWidget {
  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Colors.green[100],
      child: Text('Lecteur audio'),
    );
  }
}

/// **************
/// De quoi avoir des flèches faciles à utiliser et qui changent de couleur si besoin
class ChangeStepArrow extends StatelessWidget {
  static const right = 'droite';
  static const left = 'gauche';

  final Function arrowAction;
  final String direction;

  ChangeStepArrow({this.arrowAction, this.direction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: arrowAction,
      child: Image.asset(
        'assets/icons/96/fleche-$direction.png',
        height: 40,
        // Grisée si inactive
        color:
            (arrowAction != null) ? Theme.of(context).accentColor : Colors.grey,
      ),
    );
  }
}
