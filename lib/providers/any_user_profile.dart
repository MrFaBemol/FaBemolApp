import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AnyUserProfile with ChangeNotifier {
  bool _isLoaded = false;

  String userId = 'none';
  String email;
  String username;
  String description;
  int color;

  String profilePicture;
  String coverPicture;

  int nbSubscribers;
  int nbSubscriptions;

  Map<String, dynamic> progression;

  bool get hasProfilePicture {
    return this.profilePicture != null && this.profilePicture != '';
  }

  bool get hasCoverPicture {
    return this.coverPicture != null && this.coverPicture != '';
  }

  bool get isMainUser {
    return this.userId == FirebaseAuth.instance.currentUser.uid;
  }

  /// ***********************************************************************************************   LES FONCTIONS POUR LES LECONS
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

  //**********************************************
  //******    Récupère les infos de l'utilisateur
  //**********************************************
  Future<void> fetchUserInfo(String user) async {
    // Si ce n'est pas encore chargé dans le provider on envoie la requête et tout le bazar
    if (!_isLoaded || user != this.userId) {
      clearUser();
      this.userId = user;
      this._isLoaded = true;

      await FirebaseFirestore.instance.collection('users').doc(this.userId).get().then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data();

          // Les infos de base
          this.email = data['email'];
          this.username = data['username'];
          this.description = data['description'];
          this.color = data['color'];
          this.progression = data['progression'];

          // Les images de profil / couverture
          this.profilePicture = data['profilePicture'] != null ? data['profilePicture'] : '';
          this.coverPicture = data['coverPicture'] != null ? data['coverPicture'] : '';

          // Les abonnés / abonnements
          this.nbSubscribers = data['nbSubscribers'] != null ? data['nbSubscribers'] : 0;
          this.nbSubscriptions = data['nbSubscriptions'] != null ? data['nbSubscriptions'] : 0;
        }
        notifyListeners();
      });
    }
  }

  /// *********************************************
  /// Une fonction simple pour clear les variables
  /// *********************************************
  void clearUser() {
    this._isLoaded = false;
    this.userId = 'none';
    this.email = '';
    this.username = '';
    this.description = '';
    this.color = 0;
    this.progression = {};
    this.profilePicture = '';
    this.coverPicture = '';
  }
}
