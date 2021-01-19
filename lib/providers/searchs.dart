import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Searchs with ChangeNotifier {

  QueryDocumentSnapshot lastDocument;

  /// *********************************************
  /// Renvoie true si l'utilisateur existe (son pseudo)
  /// *********************************************
  Future<bool> usernameExists(String username) async {
    // On vérifie que l'username n'est pas déjà pris !
    QuerySnapshot docs = await FirebaseFirestore.instance
        .collection('users')
        .where('username_lowercase', isEqualTo: username.toLowerCase())
        .get();

    // Et on renvoie true s'il y en a plus qu'un
    return docs.size > 0;
  }



  /// *********************************************
  /// Renvoie le nombre d'utilisateur qui correspondent à la recherche
  /// *********************************************
  Future<int> searchNbUser(String search) async {
    // On récup tous les utilisateurs correspondants
    QuerySnapshot docs = await FirebaseFirestore.instance
        .collection('users')
        .where('searchSubstrings', arrayContains: search)
        .get();

    // Et on renvoie le nombre
    return docs.size;
  }

  Future<List<Map<String, dynamic>>> searchUsers({
    @required String search,
    int limit = 1,
    bool startAfterLastDocument = false,
  }) async {

    List<Map<String, dynamic>> resultsList = [];

    try{
      // On récup tous les utilisateurs correspondants, avec la limite tout de même ;) ;) ;) ;)
      QuerySnapshot docs = await FirebaseFirestore.instance
          .collection('users')
          .where('searchSubstrings', arrayContains: search)
          .limit(limit)
          .orderBy('creationDate')
          .get();

      // On parcourt tous les résultats
      docs.docs.forEach((doc) {
        // On enregistre ceci comme étant le dernier document (on aurait pu faire un if pour le faire qu'une fois, mais tant pis)
        this.lastDocument = doc;

        // On récup la map dont on extrait les données
        Map<String, dynamic> resultMap = doc.data();
        // On ajoute tout ça à la liste de résultats !
        resultsList.add({
          'userId' : doc.id,
          'username': resultMap['username'] ,
          'description': resultMap['description'] != null ? resultMap['description'] : '',
          'profilePicture' : resultMap['profilePicture'] != null ? resultMap['profilePicture'] : '',
          'color' : resultMap['color'],
        });

      });
    } catch(e){
      print ('erreur de base de données');
    }


    return resultsList;
  }
}
