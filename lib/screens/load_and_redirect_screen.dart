import 'dart:async';

import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/providers/ad_manager.dart';
import 'package:FaBemol/providers/lessons_structure.dart';
import 'package:FaBemol/providers/rankings.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/screens/auth_screen.dart';
import 'package:FaBemol/screens/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

class LoadAndRedirectScreen extends StatefulWidget {
  @override
  _LoadAndRedirectScreenState createState() => _LoadAndRedirectScreenState();
}

class _LoadAndRedirectScreenState extends State<LoadAndRedirectScreen> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult _connectivityResult;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }


  @override
  Widget build(BuildContext context) {

    // S'il n'y a pas internet, on retourne la waiting page.
    if (this._connectivityResult == ConnectivityResult.none || this._connectivityResult == null) {
      return WaitingPage();
    }


    // SInon le streambuilder avec firebase
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        // On affiche rien si on attends la connection
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return WaitingPage();
        }

        // Changement de la langue si elle n'existe pas dans les langues possibles :
        if (!DATA.LANGUAGES.containsKey(translator.currentLanguage)) {
          translator.setNewLanguage(context, newLanguage: DATA.DEFAULT_LANGUAGE, restart: true, remember: true);
        }

        // Si l'utilisateur est connecté à firestore
        if (userSnapshot.hasData) {
          // Si l'utilisateur n'est pas encore chargé :
          if (!Provider.of<UserProfile>(context).isLoaded) {
            //print("LOAD DE L'UTILISATEUR");
            Provider.of<UserProfile>(context, listen: false).fetchUserInfo();
            Provider.of<LessonsStructure>(context, listen: false).fetchLessonsStructure();
            Provider.of<Rankings>(context, listen: false).fetchRankings();
            Provider.of<AdManager>(context, listen: false).initRewardedAd();
            return WaitingPage();
          }
          return TabsScreen(index: Provider.of<UserProfile>(context, listen: false).tabIndex);
        } else {
          return AuthScreen();
        }
      },
    );
  }





  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    ConnectivityResult reaskResult = await _connectivity.checkConnectivity();
    switch (reaskResult) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => this._connectivityResult = reaskResult);
        break;
      default:
        setState(() => this._connectivityResult = ConnectivityResult.none);
        break;
    }
  }




}


// @todo: une vraie page de chargement
// avec des phrases marrantes hihihihihihihihi
class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}





