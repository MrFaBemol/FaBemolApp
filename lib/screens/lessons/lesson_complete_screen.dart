import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/providers/ad_manager.dart';
import 'package:FaBemol/providers/lesson.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonCompleteScreen extends StatefulWidget {
  static const String routeName = '/lessons-complete';

  @override
  _LessonCompleteScreenState createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen> {
  bool isLoading = false;
  bool rewardedAdWatched = false;

  /// *********************************************
  /// Le callback quand on clique sur le bouton (enregistre la progression et les gemmes gagnées)
  /// *********************************************
  void endLesson(BuildContext context, int reward) async {
    setState(() {
      isLoading = true;
    });
    // On récup le provider
    var lessonProvider = Provider.of<Lesson>(context, listen: false);
    // On complete la leçon dans la base de données
    await Provider.of<UserProfile>(context, listen: false).completeLesson(
      lessonProvider.catId,
      lessonProvider.lessonId,
    );
    await Provider.of<UserProfile>(context, listen: false).earnCurrency(reward);
    Provider.of<AdManager>(context, listen: false).showInterstitialAd();
  }

  @override
  void initState() {
    super.initState();
    // On initialise le firebase admob
    Provider.of<AdManager>(context, listen: false).initAdMob();
    // On charge une pub déjà comme ça c'est fait.
    Provider.of<AdManager>(context, listen: false).initRewardedAd(rewardedCallback: () {
      setState(() {
        rewardedAdWatched = true;
      });
    });
    Provider.of<AdManager>(context, listen: false).initInterstitialAd(closedCallback: (){Navigator.of(context).pop();});
  }

  @override
  Widget build(BuildContext context) {
    // On récup les provider
    var lessonProvider = Provider.of<Lesson>(context, listen: false);
    var adManager = Provider.of<AdManager>(context);

    // On récupère la récompense de base, différente si c'est une révision et non pas une première fois
    double baseReward =
        (Provider.of<UserProfile>(context, listen: false).hasCompletedLesson(lessonProvider.lessonId)) ? DATA.COMPLETE_LESSON_REVISION_REWARD : DATA.COMPLETE_LESSON_REWARD;

    // On récupère les modificateurs pour la monnaie
    double difficultyFactor = DATA.COMPLETE_LESSON_DIFFICULTY_REWARD[lessonProvider.difficulty];
    double costFactor = DATA.COMPLETE_LESSON_COST_REWARD[lessonProvider.cost];

    // On calcule le total
    double totalReward = baseReward * costFactor * difficultyFactor;
    // On multiplie si la récompense si une vidéo a été regardée
    totalReward *= rewardedAdWatched ? DATA.COMPLETE_LESSON_REWARDED_AD : 1;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ContainerFlatDesign(
            screenWidth: true,
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Image.asset('assets/icons/240/couronne-de-laurier.png', width: 120),
                AutoSizeText('Leçon terminée !', style: Theme.of(context).textTheme.headline5, maxLines: 1), // @todo: trad
                SizedBox(height: 20),

                // La récompense de base *****************************************************************************************
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      'lesson_reward'.tr() + ' :',
                      maxLines: 1,
                      style: TextStyle(fontWeight: (difficultyFactor != 1 || costFactor != 1 || rewardedAdWatched) ? FontWeight.normal : FontWeight.bold),
                    ),
                    Expanded(child: Container()),
                    AutoSizeText(
                      baseReward.toStringAsFixed(0),
                      style: TextStyle(fontWeight: (difficultyFactor != 1 || costFactor != 1 || rewardedAdWatched) ? FontWeight.normal : FontWeight.bold),
                    ),
                    Image.asset('assets/icons/96/topaze.png', height: 20),
                  ],
                ),
                SizedBox(height: 10),

                // Si on a un multiplicateur de coût, on l'affiche
                if (costFactor != 1)
                  Row(
                    children: [
                      AutoSizeText('lesson_reward_cost_bonus'.tr() + ' :', maxLines: 1),
                      Expanded(child: Container()),
                      AutoSizeText(
                        costFactor.truncateToDouble() != costFactor ? 'x' + costFactor.toString() : 'x' + costFactor.toStringAsFixed(0),
                        maxLines: 1,
                      ),
                    ],
                  ),

                // Si on a un multiplicateur de difficulté, on l'affiche
                if (difficultyFactor != 1)
                  Row(
                    children: [
                      AutoSizeText('lesson_reward_difficulty_bonus'.tr() + ' :', maxLines: 1),
                      Expanded(child: Container()),
                      AutoSizeText(
                        difficultyFactor.truncateToDouble() != difficultyFactor ? 'x' + difficultyFactor.toString() : 'x' + difficultyFactor.toStringAsFixed(0),
                        maxLines: 1,
                      ),
                    ],
                  ),

                // Si on a un multiplicateur de publicité
                if (rewardedAdWatched)
                  Row(
                    children: [
                      AutoSizeText('lesson_reward_rewarded_ad_bonus'.tr() + ' :', maxLines: 1),
                      Expanded(child: Container()),
                      AutoSizeText('x' + DATA.COMPLETE_LESSON_REWARDED_AD.truncate().toString(), maxLines: 1),
                    ],
                  ),

                // Le total à afficher s'il y a des modificateurs
                if (difficultyFactor != 1 || costFactor != 1 || rewardedAdWatched) Divider(color: Theme.of(context).shadowColor),
                if (difficultyFactor != 1 || costFactor != 1 || rewardedAdWatched)
                  Row(
                    children: [
                      AutoSizeText(
                        'lesson_reward_total'.tr() + ' :',
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Container()),
                      AutoSizeText(
                        totalReward.truncate().toString(),
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Image.asset('assets/icons/96/topaze.png', height: 20),
                    ],
                  ),

                SizedBox(height: 20),
                // Le loading circle qui s'affiche quand on termine la leçon
                if (isLoading) CircularProgressIndicator(),

                // Le bouton pour regarder les publicités
                if (!isLoading)
                  Container(
                    width: 200,
                    child: ElevatedButton(
                      // On active le bouton seulement si l'utilisateur n'a pas encore lancé une vidéo pour avoir le bonus
                      onPressed: !rewardedAdWatched
                          ? () {
                              adManager.showRewardedAd();
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText('button_watch'.tr() + ' ', maxLines: 1),
                          Image.asset('assets/icons/96/topaze.png', height: 20),
                          AutoSizeText('x' + DATA.COMPLETE_LESSON_REWARDED_AD.truncate().toString(), maxLines: 1),
                        ],
                      ),
                    ),
                  ),
                // Le bouton pour terminer la leçon et cie
                if (!isLoading)
                  Container(
                    width: 200,
                    child: OutlinedButton(
                      onPressed: () {
                        endLesson(context, totalReward.truncate());
                      },
                      child: AutoSizeText('button_continue'.tr(), maxLines: 1),
                    ),
                  ),

                SizedBox(height: 20),
                if (!rewardedAdWatched)
                  AutoSizeText('ad_rewarded_complete_lesson_label'.tr(), textAlign: TextAlign.center, style: TextStyle(fontSize: 14),),
                if (rewardedAdWatched) AutoSizeText("Merci beaucoup !" , textAlign: TextAlign.center, style: TextStyle(fontSize: 14),),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
