import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class AdManager with ChangeNotifier {

  MobileAdTargetingInfo adTargetInfos = MobileAdTargetingInfo(keywords: ['Music', 'Learning', 'Piano']);

  // Banner
  bool bannerAdLoaded = false;

  // Rewarded
  bool rewardedVideoAdLoaded = false;

  // Interstitial
  InterstitialAd interstitialAd;
  bool interstitialAdLoaded = false;

  Future<void> initAdMob() {
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }



  /// *********************************************
  /// Initialise une pub interstitielle (les paramètres sont les callback à appeler)
  /// *********************************************
  void initInterstitialAd({
    Function loadedCallback,
    Function closedCallback,
    Function failedToLoadCallback,
  }) {
    this.interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      targetingInfo: this.adTargetInfos,
      listener: (MobileAdEvent event){
        switch (event) {
          case MobileAdEvent.loaded:
            interstitialAdLoaded = true;
            loadedCallback?.call();
            break;
          case MobileAdEvent.failedToLoad:
            interstitialAdLoaded = false;
            print('Failed to load an interstitial ad');
            failedToLoadCallback?.call();
            break;
          case MobileAdEvent.closed:
            closedCallback?.call();
            break;
          default:
          // do nothing
        }
      }
    );

    this.interstitialAd.load();
  }

  void showInterstitialAd(){
    this.interstitialAd.show();
  }
  void disposeInterstitialAd(){
    this.interstitialAd.dispose();
  }

  /// *********************************************
  /// Initialise une pub avec récompense (les paramètres sont les callback à appeler)
  /// *********************************************
  void initRewardedAd({
    Function loadedCallback,
    Function closedCallback,
    Function failedToLoadCallback,
    Function rewardedCallback,
  }) {
    // La fonction qui va se charger de tout ce qu'il faut avec le gros switch
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      switch (event) {
        case RewardedVideoAdEvent.loaded:
          this.rewardedVideoAdLoaded = true;
          print('********************************* Rewarded chargée *******************************');
          loadedCallback?.call();
          break;

        case RewardedVideoAdEvent.closed:
          this.rewardedVideoAdLoaded = false;
          closedCallback?.call();
          // On recharge une nouvelle vidéo
          _loadRewardedAd();
          break;

        case RewardedVideoAdEvent.failedToLoad:
          this.rewardedVideoAdLoaded = false;
          failedToLoadCallback?.call();
          print('Failed to load a rewarded ad');
          break;

        case RewardedVideoAdEvent.rewarded:
          rewardedCallback?.call();
          break;
        default:
        // do nothing
      }
      // On dit aux pages que la vidéo est bien chargée (ou non selon le cas)
      notifyListeners();
    };

    // On load une première pub
    _loadRewardedAd();
  }

  /// *********************************************
  /// Charge une pub avec récompense
  /// *********************************************
  void _loadRewardedAd() {
    // On ne charge rien si la vidéo est déjà là.
    if (this.rewardedVideoAdLoaded) {
      print('********************************* Déjà chargée *******************************');
      return;
    }
    // On lance le chargement
    RewardedVideoAd.instance.load(
      targetingInfo: this.adTargetInfos,
      adUnitId: AdManager.rewardedAdUnitId,
    );
  }

  /// *********************************************
  /// Réinitialise le listener de la pub avec récompense
  /// *********************************************
  void clearRewardedAd() {
    RewardedVideoAd.instance.listener = null;
  }

  /// *********************************************
  /// Affiche la publicité avec récompense chargée
  /// *********************************************
  void showRewardedAd() {
    RewardedVideoAd.instance.show();
  }

  /// *********************************************
  /// Les getters des id pour les pubs
  /// *********************************************
  static String get appId {
    if (Platform.isAndroid) {
      // Mon code : ca-app-pub-5752312593352673~2616181598
      return "ca-app-pub-3940256099942544~4354546703";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~2594085930"; // Non ajouté dans les fichiers iOS
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8865242552";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4339318960";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // Mon code : ca-app-pub-5752312593352673/3485567216
      return "ca-app-pub-3940256099942544/7049598008";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3964253750";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      // Mon code : ca-app-pub-5752312593352673/8080261264
      return "ca-app-pub-3940256099942544/8673189370";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/7552160883";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
