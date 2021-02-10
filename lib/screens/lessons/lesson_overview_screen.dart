import 'package:FaBemol/providers/lesson.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/screens/lessons/lesson_steps_screen.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:FaBemol/widgets/item_life_cost_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:provider/provider.dart';

class LessonOverviewScreen extends StatefulWidget {
  static const String routeName = '/lessons-overview';

  @override
  _LessonOverviewScreenState createState() => _LessonOverviewScreenState();
}

class _LessonOverviewScreenState extends State<LessonOverviewScreen> {
  bool isLoading = false;

  // La fonction qui charge la leçon et change de screen
  void loadAndStartLesson(String catId, String lessonId, int lessonCost) async {
    setState(() {
      isLoading = true;
    });

    try {
      // On charge la leçon
      await Provider.of<Lesson>(context, listen: false)
          .loadLessonFromDB(catId, lessonId);
      // On utilise le nombre de vies
      await Provider.of<UserProfile>(context, listen: false)
          .useLives(lessonCost);

      // On s'envole vers la nouvelle page.
      Navigator.of(context).pushReplacementNamed(LessonStepsScreen.routeName);
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // On récup la leçon
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    // Et on extrait les données pour que ce soit plus clair
    final String catId = args['catId'];
    final String lessonId = args['lesson']['id'];
    final String lessonIcon = args['lesson']['icon'];
    final int lessonDifficulty = args['lesson']['difficulty'];
    final int lessonCost = args['lesson']['cost'];
    // Ici on fait en fonction de la langue
    final String lessonTitle =
        (args['lesson']['title'][translator.currentLanguage] != null)
            ? args['lesson']['title'][translator.currentLanguage]
            : args['lesson']['title']['en'];
    final String lessonDescription =
        (args['lesson']['title'][translator.currentLanguage] != null)
            ? args['lesson']['description'][translator.currentLanguage]
            : args['lesson']['description']['en'];

    final bool hasEnoughLives = Provider.of<UserProfile>(context, listen: false)
        .hasEnoughLives(lessonCost);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Le container flatdesign pour l'icone, le titre et la description
                ContainerFlatDesign(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    children: [
                      Hero(
                        tag: 'icon_$lessonId',
                        child: Image.network(
                          lessonIcon,
                          height: 144,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Hero(
                        tag: 'title_$lessonId',
                        child: AutoSizeText(
                          lessonTitle,
                          style: Theme.of(context).textTheme.headline4,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Hero(
                        tag: 'difficulty_$lessonId',
                        child: Text(
                          'difficulty$lessonDifficulty'.tr().toUpperCase(),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        width: 200,
                        height: 150,
                        child: SingleChildScrollView(
                          child: AutoSizeText(
                            lessonDescription,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.fade,
                          ),
                          scrollDirection: Axis.vertical,
                        ),
                      ),
                    ],
                  ),
                ),


                // Le cout et les boutons *******************************************************
                SizedBox(height: 20),

                // @ todo: ajouter une animation pour envoyer la leçon ?
                // @todo : changer le texte si l'utilisateur a déjà terminé la leçon (révision)
                LifeCostText(lessonCost),

                SizedBox(height: 5),

                //***  Les boutons
                if (!isLoading && hasEnoughLives)
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        loadAndStartLesson(catId, lessonId, lessonCost);
                      },
                      child: AutoSizeText('start_lesson'.tr()),
                    ),
                  ),
                if (!isLoading && !hasEnoughLives)
                  Container(
                    width: 200,
                    margin: EdgeInsets.all(5),
                    child: AutoSizeText(
                      'error_not_enough_lives'.tr(),
                      style: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                if (!isLoading)
                  Container(
                    width: 200,
                    child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: AutoSizeText('button_back'.tr())),
                  ),

                // Si on charge on envoie un circularProgress
                if (isLoading) SizedBox(height: 50),
                if (isLoading) CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
