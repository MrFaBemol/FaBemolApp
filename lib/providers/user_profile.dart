import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class UserProfile with ChangeNotifier {
  bool isLoaded = false;
  bool _isLoading = false;
  int tabIndex = 2;

  String userId;
  String email;
  String username;
  String description;
  int color;
  int currencyBalance;

  String profilePicture;
  String coverPicture;

  int nbSubscribers;
  int nbSubscriptions;

  Map<String, dynamic> lives;

  /*
  progression est tout simplement une map de type :
  progression = {
    'catId1' : [lessonId1, lessonId2, ...],
    'catId2' : [lessonId1, lessonId2, ...],
  }
   */
  Map<String, dynamic> progression;

  bool get hasProfilePicture {
    return this.profilePicture != null && this.profilePicture != '';
  }

  bool get hasCoverPicture {
    return this.coverPicture != null && this.coverPicture != '';
  }

  bool get isMainUser {
    return true;
  }

  void setTabIndex(int index) {
    this.tabIndex = index;
  }

  //********************************************************************************************************************************* LOG IN / LOG OUT
  //******    Récupère les infos de l'utilisateur
  //**********************************************
  Future<void> fetchUserInfo() async {
    // Si ce n'est pas encore chargé dans le provider et que ce n'est pas en chargement actuellement
    // Alors on envoie la requête et tout le bazar
    if (!isLoaded && !_isLoading) {
      // ça y est, on charge !
      _isLoading = true;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get();

      // Si le document existe
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data();

        // Les infos de base
        this.userId = FirebaseAuth.instance.currentUser.uid;
        this.email = data['email'];
        this.username = data['username'];
        this.description = data['description'];
        this.color = data['color'];
        this.progression = data['progression'];
        this.lives = data['lives'];
        this.currencyBalance = data['currencyBalance'] != null ? data['currencyBalance'] : 0;

        // Les images de profil / couverture
        this.profilePicture = data['profilePicture'] != null ? data['profilePicture'] : '';
        this.coverPicture = data['coverPicture'] != null ? data['coverPicture'] : '';

        // Les abonnés / abonnements
        this.nbSubscribers = data['nbSubscribers'] != null ? data['nbSubscribers'] : 0;
        this.nbSubscriptions = data['nbSubscriptions'] != null ? data['nbSubscriptions'] : 0;

        isLoaded = true;
      }

      // C'est bon on a terminé les opération asynchrones !
      _isLoading = false;
      notifyListeners();
    }

    // Dans tous les cas on update les vies.
    updateLives();
  }

  /// *********************************************
  /// Une fonction simple pour clear les variables lors de la déconnexion
  /// *********************************************
  void logoutUser() {
    this.isLoaded = false;
    this.email = '';
    this.username = '';
    this.description = '';
    this.color = 0;
    this.progression = {};
    this.lives = {};
    this.profilePicture = '';
    this.coverPicture = '';
    // On se déconnecte
    FirebaseAuth.instance.signOut();
  }





  //***************************************************************************************************************************************** CURRENCY
  //Renvoie true si l'utilisateur a assez de vies
  bool hasEnoughCurrency(int quantity) {
    return quantity <= this.currencyBalance;
  }

  /// *********************************************
  /// Dépense de la monnaie
  /// *********************************************
  Future<void> spendCurrency(int quantity) async {
    // L'ultime check, car on sait si on essaye d'arnaquer l'application ;) ;) ;)
    if (!hasEnoughCurrency(quantity)) return;

    try {
      // On envoie la requête
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
        'currencyBalance': this.currencyBalance - quantity,
      });
      // On fait les changements en interne
      this.currencyBalance -= quantity;
      // On prévient les listeners
      notifyListeners();
    } catch (err) {
      print('Erreur : Impossible de dépenser la monnaie => ' + err.toString());
    }
  }

  /// *********************************************
  /// Gagne de la monnaie !
  /// *********************************************
  Future<void> earnCurrency(int quantity) async {
    try {
      // On envoie la requête
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
        'currencyBalance': this.currencyBalance + quantity,
      });
      // On fait les changements en interne
      this.currencyBalance += quantity;
      // On prévient les listeners
      notifyListeners();
    } catch (err) {
      print('Erreur : Impossible de gagner de la monnaie => ' + err.toString());
    }
  }


  //******************************************************************************************************************************************** LIVES
  // Renvoie le nombre de vies
  int get livesCount {
    return (lives != null) ? lives['count'] : 0;
  }

  // Renvoie le nombre de vies max
  int get livesMax {
    return (lives != null) ? lives['max'] : 5;
  }

  // Renvoie true si les vies sont pleines
  bool get livesFull {
    return livesCount >= livesMax; // Si l'utilisateur a autant ou plus de vie que le max
  }

  // Renvoie le nombre de secondes avant la prochaine vie.
  int get timeToNextLife {
    return (lives != null) ? lives['nextLifeTimestamp'] - Timestamp.now().seconds : 200000;
  }

  //Renvoie true si l'utilisateur a assez de vies
  bool hasEnoughLives(int quantity) {
    return quantity <= lives['count'];
  }

  ///**********************************************
  ///******    Paye le coût en vie
  ///**********************************************
  Future<void> useLives(int quantity) async {
    // Un ultime check pour voir s'il y a assez de vies (est déjà vérifié dans le widget qui appelle la fonction, mais on sait jamais)
    if (!hasEnoughLives(quantity))return;

    try {
      // Si les vies sont pleines, il faut calculer le nouveau timestamp, sinon on garde l'ancien.
      int nextTimestamp = (livesFull) ? Timestamp.now().seconds + lives['timer'] : lives['nextLifeTimestamp'];

      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
        'lives.count': lives['count'] - quantity,
        'lives.nextLifeTimestamp': nextTimestamp,
      });

      // On fait les changements en interne
      lives['count'] -= quantity;
      lives['nextLifeTimestamp'] = nextTimestamp;

      notifyListeners();
    } catch (err) {
      print('Erreur : Impossible d\'utiliser les vies :' + err.toString());
    }
  }

  /// *********************************************
  /// Calcule les vies à ajouter depuis la dernière connexion / mise à jour
  /// *********************************************
  Future<void> updateLives() async {
    // Si les vies sont pleines et si le temps est négatif, alors on a dépassé le timer
    if (!livesFull && timeToNextLife <= 0) {
      // On fait une copie des vies et du temps passé pour pas boucler direct dessus
      int newLives = lives['count'];
      int overtime = timeToNextLife * -1; // Le nombre de secondes en mode positif

      // On s'arrête de boucler soit quand on arrive au nombre max de vies, soit quand on a fait assez de "modulo" du temps de récup des vies
      while (newLives < lives['max'] && overtime > 0) {
        overtime -= lives['timer'];
        newLives++;
      }

      // Si on est passé à 5 on s'en fout du timestamp, mais sinon on doit le calculer : now() + overtime*-1
      int newNextLifeTimestamp = (newLives == 5) ? Timestamp.now().seconds : Timestamp.now().seconds + (overtime * -1);

      try {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
          'lives.count': newLives,
          'lives.nextLifeTimestamp': newNextLifeTimestamp,
        });

        // On fait les changements en interne
        lives['count'] = newLives;
        lives['nextLifeTimestamp'] = newNextLifeTimestamp;

        notifyListeners();
      } catch (err) {
        print('Erreur : Impossible d\'update les vies :' + err.toString());
      }
    }
  }

  /// **************************************************************************************************************************************** LESSONS
  /// Renvoie le nombre de leçons terminées au total
  /// *********************************************
  int getCompletedLessons() {
    int total = 0;
    // Si aucune leçon n'est pour l'instant terminée :
    if (progression == null) return total;
    // Sinon on continue pépouze
    progression.forEach((catId, lessonList) {
      total += lessonList.length;
    });
    return total;
  }

  /// *********************************************
  /// Renvoie le nombre de leçon terminées pour la catégorie passée en argument
  /// *********************************************
  int getCompletedLessonsByCategory(String catId) {
    // Si on a aucune progression pour la catégorie (ou pas de progression du tout)
    return (progression == null || progression[catId] == null) ? 0 : progression[catId].length;
  }

  /// *********************************************
  /// Renvoie true si l'utilisateur a déjà complété la leçon passée en argument
  /// *********************************************
  bool hasCompletedLesson(String lessonId) {
    // On parcourt la map de progression, et on valide si on trouve la leçon déjà validée
    for (final completedLessons in progression.values) {
      if (completedLessons.contains(lessonId)) {
        return true;
      }
    }
    return false; // Si on a parcouru tous les arrays pour rien.
  }

  ///**********************************************
  ///******    Valide la leçon dans la progression
  ///**********************************************
  Future<void> completeLesson(String catId, String lessonId) async {
    // Si c'est une révision, pas besoin de requête
    if (this.hasCompletedLesson(lessonId)) return;

    try {
      // On envoie la requete pour ajouter la valeur
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
        'progression.' + catId: FieldValue.arrayUnion([lessonId])
      });

      // On gère la progression du provider
      if (this.progression[catId] == null) {
        // Si c'est la première leçon de cette catégorie, on crée l'index dans la map avec le tableau
        this.progression[catId] = [lessonId];
      } else {
        // Si c'est la première fois que l'utilisateur finit la leçon, alors on peut l'ajouter à la progression
        if (!this.progression[catId].contains(lessonId)) {
          this.progression[catId].add(lessonId);
        }
      }

      notifyListeners();
    } catch (err) {
      print('Erreur : Progression non mise à jour ');
    }
  }

  ///**********************************************
  ///   Réinitialise complètement la progression
  ///**********************************************
  Future<void> resetProgression() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({
        'progression': {},
      });
      this.progression = {};
      notifyListeners();
    } catch (err) {
      print('Erreur : impossible de reset la progression');
    }
  }

  /// ****************************************************************************************************************************  PROFILE PICTURE
  /// Change une image du profil (soit l'avatar, soit la couverture)
  /// *********************************************
  Future<void> changePicture(File file, String pictureType) async {
    // Un timstamp pour créer un nom de fichier unique en combinaison avec l'userId
    String uniqueId = Timestamp.now().seconds.toString();
    // On prépare notre requête
    final ref = FirebaseStorage.instance
        .ref()
        .child('users_' + pictureType) // Le dossier image profile/cover
        .child(this.userId) // Le dossier de l'utilisateur
        .child(uniqueId);

    try {
      // On envoie la requête
      await ref.putFile(file);
      // On récupère l'url à mettre dans le profil.
      final url = await ref.getDownloadURL();
      //print(url.toString());

      // On envoie la nouvelle image dans le profil
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).update({pictureType: url});

      this.profilePicture = (pictureType == 'profilePicture') ? url : this.profilePicture;
      this.coverPicture = (pictureType == 'coverPicture') ? url : this.coverPicture;

      notifyListeners();
    } catch (e) {
      print("erreur d'upload : " + e.toString());
    }
  }

  /// *********************************************
  /// Renvoie la liste des sous-chaines de caractères qui permettront de rechercher l'utilisateur
  /// *********************************************
  List<String> getSearchSubstrings({String username = '', String email = ''}) {
    List<String> searchSubstrings = [];

    // On prend l'username / email de l'utilisateur si aucun n'est passé en arguments.
    // On met tout en minuscule pour pas faire de problème (de toute façon c'est juste pour la recherche)
    username = username == '' ? this.username.toLowerCase() : username.toLowerCase();
    email = email == '' ? this.email.toLowerCase() : email.toLowerCase();

    // On ajoute l'username et l'email
    searchSubstrings.add(username);
    searchSubstrings.add(email);

    // On parcourt le nom d'utilisateur et on génère les substrings (minimum 3 caractères car c'est le mini pour un username)
    for (int i = 3; i < username.length; i++) {
      // à l'endroit
      searchSubstrings.add(username.substring(0, i));
      // à l'envers
      searchSubstrings.add(username.substring(username.length - i, username.length));
    }

    //print(searchSubstrings);
    return searchSubstrings;
  }
}
