import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

///
/// Gère la structure des leçons
/// C'est une grande map avec :
///   - des catégories divisées en
///     - sous catégories, elle mêmes divisées en
///       - chapitres qui sont des arrays de
///         - leçons (des maps avec les infos minimales de la leçon (id, titre, description, etc..)).
class LessonsStructure with ChangeNotifier {

  /* La structure est de forme :
  lessonsStructure = {
    'catId' : {
      nbLessons : 12,
      structure : {
        'subCatId1' : {
          'chapterId1' : [0: Lesson1, 1, Lesson2],
          'chapterId2' : [0: Lesson1, 1, Lesson2],
        }
        'subCatId1' : {
          'chapterId1' : [0: Lesson1, 1, Lesson2],
          'chapterId2' : [0: Lesson1, 1, Lesson2],
        }
      } // structure
    }   // catId
  }     // lessonsStructure
   */
  Map<String, dynamic> lessonsStructure = {};
  bool _isLoading = false;



  // Renvoie le nombre de lessons total dans une catégorie
  int getNbLessons(String catId) {
    return lessonsStructure[catId] != null ? lessonsStructure[catId]['nbLessons'] : -1;
  }

  // ***** De quoi récupérer les noms des sous categories dans une liste ordonnée
  List<String> getSubCategoriesOrder(String catId) {
    // On les récupère en List de dynamic et on les transforme en List de String
    List<dynamic> subCategoriesOrder = lessonsStructure[catId]['subCategoriesOrder'];
    return subCategoriesOrder.map((e) => e.toString()).toList();
  }

  // ***** De quoi récupérer les noms des chapitres dans une liste ordonnée
  List<String> getChaptersOrder(String catId, String subCatId) {
    // On les récupère en List de dynamic et on les transforme en List de String
    List<dynamic> chaptersOrder = lessonsStructure[catId]['chaptersOrder'][subCatId];
    return chaptersOrder.map((e) => e.toString()).toList();
  }

  // **** Envoie la liste des leçons avec leurs infos
  List<dynamic> getLessonsFromChapter(String catId, String subCatId, String chapterId){
    //print(lessonsStructure[catId]['structure'][subCatId][chapterId]);
    return lessonsStructure[catId]['structure'][subCatId][chapterId];
  }

  //**********************************************
  //******    Récupère la structures des leçons
  //**********************************************
  Future<void> fetchLessonsStructure({bool forceReload = false}) async {
    if ((lessonsStructure.isNotEmpty || _isLoading) && !forceReload) {
      return;
    }

    _isLoading = true;
    print("Chargement de l'arbre des leçons...");
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((category) {
        // On récupère les données dans une map
        Map<String, dynamic> data = category.data();
        // On enregistre dans la structure du provider
        lessonsStructure[category.id] = {
          'nbLessons': data['nbLessons'],
          'structure': data['structure'],
          'subCategoriesOrder': data['subCategoriesOrder'],
          'chaptersOrder': data['chaptersOrder'],
        };
      });
      //print(lessonsStructure.toString());

      notifyListeners();
      _isLoading = false;
    });
  }
//****************************   Fin de la fonction de fetch




}
