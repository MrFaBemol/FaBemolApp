import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/providers/ad_manager.dart';
import 'package:FaBemol/providers/lessons_structure.dart';
import 'package:FaBemol/providers/rankings.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/screens/auth_screen.dart';
import 'package:FaBemol/screens/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class LoadAndRedirectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //print('redirect page');

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot) {
        // On affiche rien si on attends la connection
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return WaitingPage();
        }


        // Changement de la langue si elle n'existe pas dans les langues possibles :
        if (!DATA.LANGUAGES.containsKey(translator.currentLanguage)){
          translator.setNewLanguage(context, newLanguage: DATA.DEFAULT_LANGUAGE, restart: true, remember: true);
        }

        // Si l'utilisateur est connecté à firestore
        if (userSnapshot.hasData) {
          // Si l'utilisateur n'est pas encore chargé :
          if (! Provider.of<UserProfile>(context).isLoaded ){
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
}


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
