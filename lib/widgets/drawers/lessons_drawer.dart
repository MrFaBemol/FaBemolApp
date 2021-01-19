import 'package:FaBemol/providers/ad_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LessonsDrawer extends StatefulWidget {
  @override
  _LessonsDrawerState createState() => _LessonsDrawerState();
}

class _LessonsDrawerState extends State<LessonsDrawer> {
  int _coins = 0;

  void addCoins(int quantity) {
    setState(() {
      _coins += quantity;
    });
  }

  @override
  void initState() {
    super.initState();
    // On initialise le firebase admob
    Provider.of<AdManager>(context, listen: false).initAdMob();
    // On charge une pub déjà comme ça c'est fait.
    Provider.of<AdManager>(context, listen: false).initRewardedAd(rewardedCallback: () {
      addCoins(5);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    print('dispose');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var adManager = Provider.of<AdManager>(context);

    return Drawer(
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('Drawer de gôche', style: TextStyle(fontSize: 32)),
              Text('Nombre de coins : ' + _coins.toString()),
              ElevatedButton(
                onPressed: adManager.rewardedVideoAdLoaded
                    ? () {
                        adManager.showRewardedAd();
                      }
                    : null,
                child: adManager.rewardedVideoAdLoaded ? Text('Lancer la vidéo') : Text('Chargement...'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
