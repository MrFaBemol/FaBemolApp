import 'dart:async';

import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/functions/rounded_modal_bottom_sheet.dart';
import 'package:FaBemol/providers/ad_manager.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:FaBemol/functions/numbers.dart';

class LivesCounterWidget extends StatefulWidget {
  @override
  _LivesCounterWidgetState createState() => _LivesCounterWidgetState();
}

class _LivesCounterWidgetState extends State<LivesCounterWidget> {
  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = Provider.of<UserProfile>(context);
    userProfile.updateLives();
    int livesNumber = userProfile.livesCount;

    return InkWell(
      onTap: () {
        showRoundedMBS(
          context: context,
          child: LivesBottomSheet(),
        );
      },
      child: Row(
        children: [
          Image.asset(
            'assets/icons/96/music-heart.png',
            height: 28,
          ),
          SizedBox(width: 4),
          AutoSizeText(
            livesNumber.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

/// *********************************************
/// La bottom sheet avec le timer et la possibilité de regarder une vidéo
/// *********************************************
class LivesBottomSheet extends StatefulWidget {
  @override
  _LivesBottomSheetState createState() => _LivesBottomSheetState();
}

class _LivesBottomSheetState extends State<LivesBottomSheet> {
  Timer timer;
  bool timerStarted = false;

  @override
  void initState() {
    // On initialise le firebase admob
    Provider.of<AdManager>(context, listen: false).initAdMob();
    // On charge une pub déjà comme ça c'est fait.
    Provider.of<AdManager>(context, listen: false).initRewardedAd(rewardedCallback: () {
      Provider.of<UserProfile>(context, listen: false).getLivesFromAd();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!timerStarted && mounted) {
      timerStarted = true;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {});
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProfile userProfile = Provider.of<UserProfile>(context);
    AdManager adManager = Provider.of<AdManager>(context);
    String textAboutLife42;

    bool livesFull = userProfile.livesFull;

    if (livesFull) {
      textAboutLife42 = 'lives_full'.tr();
    } else {
      // Si le temps est à zéro, on update les vies
      if (userProfile.timeToNextLife <= 0) {
        userProfile.updateLives();
      }
      // Calcul du timer et de la date formatée
      String formattedTime = userProfile.timeToNextLife.toStringTimeFormatted(clockFormat: true);
      textAboutLife42 = 'next_life'.tr() + ' : ' + formattedTime;
    }

    int livesCount = userProfile.livesCount;
    int livesMax = userProfile.livesMax;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          ContainerFlatDesign(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/icons/96/music-heart.png', height: 60),
                    AutoSizeText(livesCount.toString() + '/' + livesMax.toString(), maxLines: 1, style: Theme.of(context).textTheme.headline4)
                  ],
                ),
                SizedBox(height: 20),
                AutoSizeText(textAboutLife42, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22), maxLines: 1),

                // On peut regarder une vidéo si les vies ne sont pas pleines
                if (!livesFull) Divider(height: 50, thickness: 1, color: Theme.of(context).shadowColor,),
                if (!livesFull) AutoSizeText('ad_rewarded_get_lives_label'.tr(), textAlign: TextAlign.center,),
                if (!livesFull)
                  ElevatedButton(
                    onPressed: () {
                      adManager.showRewardedAd();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText('button_watch'.tr() + ' ', maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold),),
                        Image.asset('assets/icons/96/music-heart.png', height: 20),
                        AutoSizeText('+' + DATA.BONUS_LIVES_REWARDED_AD.truncate().toString(), maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
