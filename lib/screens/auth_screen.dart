import 'dart:math';

import 'package:FaBemol/providers/searchs.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/widgets/features_display.dart';
import 'package:FaBemol/widgets/login_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:FaBemol/data/colors.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = 'auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _displayForm = false;
  bool _isLoading = false;

  void _switchToForm() {
    setState(() {
      _displayForm = true;
    });
  }

  void _submitForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx, // Pour afficher les snackbar
  ) async {
    UserCredential userCredential; // Là où on stock les infos de l'utilisateur !

    try {
      // On affiche le Circular Progress
      setState(() {
        _isLoading = true;
      });

      // Ici on envoie la requete
      if (isLogin) {
        // On se connecte
        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

      } else {

        // On check si l'utilisateur existe
        bool userExists = await Provider.of<Searchs>(context, listen: false).usernameExists(username);

        // On crée la variable qui permet de changer le nom si besoin
        int usernameAppend = 1;
        // On boucle tant que l'utilisateur existe
        while (userExists){
          // On cherche un nouveau pseudo possible
          usernameAppend++;
          userExists = await Provider.of<Searchs>(context, listen: false).usernameExists(username + '_' + usernameAppend.toString());
        }

        // On crée le nom final de l'utilisateur
        // Si usernameAppend est supérieur à 1, ça veut dire qu'il faut modifier le pseudo
        String finalName = usernameAppend > 1 ? username + '_' + usernameAppend.toString() : username;

        // On lui pick une couleur aléatoire
        var rng = new Random();
        int nbColor = rng.nextInt(COLORS.PROFILE_COLORS.length);

        // Les extraits de String pour faire les recherches plus tard
        List<String> searchSubstrings =
            Provider.of<UserProfile>(context, listen: false)
                .getSearchSubstrings(username: finalName, email: email);

        // La date de création du compte
        int creationDate = Timestamp.now().seconds;


        // ************************************************
        // On s'inscrit dans la base pour donner les accès
        //*************************************************
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // On envoie tout dans la base pour avoir les infos publiques
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'email': email,
          'username': finalName,
          'username_lowercase': finalName.toLowerCase(),
          'creationDate': creationDate,
          'color': nbColor,
          'progression': {},
          'description': '',
          'searchSubstrings': searchSubstrings,
          'lives': {
            'max': 5,
            'count': 5,
            'timer': 28800, // = 8 heures
            'nextLifeTimestamp': creationDate,
          },
        });


      }

      // ON EXCEPTION
    } on FirebaseAuthException catch (e) {
      // @Todo : gérer les erreurs de connexion plus élégamment
      var message = 'An error occured!';

      if (e.message != null) {
        message = e.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('erreur');
      setState(() {
        _isLoading = false;
      });
    }
    // Fin du catch
  }

  // Fin de submitForm

  //******************* LE BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // ****************** LE LOGO //@todo: à créer !
          Container(
            height: 130,
            child: Center(
              child: Text(
                'FA BEMOL',
                style: TextStyle(
                    fontSize: 70,
                    color: Theme.of(context).textTheme.headline5.color),
              ),
            ),
          ),

          //******************** LE FORMULAIRE
          if (_displayForm)
            Expanded(
              child: LoginForm(_submitForm, _isLoading),
            ),

          //******************** LES FEATURES
          if (!_displayForm)
            Expanded(
              child: FeaturesDisplay(_switchToForm),
            ),
        ]),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('tests/mRwMynW4XDJdA57DBmWZ/messages')
              .snapshots()
              .listen((data) {
                data.docs.forEach((document) {
                  Map<String, dynamic> documentMap = document.data();
                  print('Texte = '+documentMap['text'] + ' / Utilisateurs taggés = ' + documentMap['taggedUsers'].toString());
                });
          });
        },
      ),
      */
    );
  }
}

//************************************************************************** LOGO
class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(200), boxShadow: [
        BoxShadow(
            color: Colors.black26,
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3))
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Image.asset(
          'assets/images/logotmp.png',
          height: 120,
        ),
      ),
    );
  }
}
