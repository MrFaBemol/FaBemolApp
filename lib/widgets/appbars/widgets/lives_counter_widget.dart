import 'dart:async';

import 'package:FaBemol/functions/rounded_modal_bottom_sheet.dart';
import 'package:FaBemol/providers/user_profile.dart';
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
          Text(
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

class LivesBottomSheet extends StatefulWidget {
  @override
  _LivesBottomSheetState createState() => _LivesBottomSheetState();
}

class _LivesBottomSheetState extends State<LivesBottomSheet> {
  Timer timer;
  bool timerStarted = false;

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
    String textAboutLife42;

    if (userProfile.livesFull) {
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/icons/96/music-heart.png', height: 65),
            AutoSizeText(livesCount.toString() + '/' + livesMax.toString(), maxLines: 1, style: Theme.of(context).textTheme.headline4)
          ],
        ),
        SizedBox(height: 30),
        AutoSizeText(textAboutLife42, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26), maxLines: 1),
      ],
    );
  }
}
