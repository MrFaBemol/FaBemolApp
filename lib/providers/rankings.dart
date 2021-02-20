import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Rankings with ChangeNotifier {
  bool isLoading = false;
  Map<String, dynamic> rankings = {};

  Future<void> fetchRankings({bool forceReload = false}) async {
    // Si on est déjà en train de load les infos ou que les rankings sont déjà chargés, pas besoin de fetch
    // Cas d'exception : Si on force le reload alors on continue (pas de return)
    //print(this.rankings);
    if ((this.isLoading || this.rankings.isNotEmpty) && !forceReload) {
      return;
    }

    this.isLoading = true;
    try {
      print("Chargement des classements...");
      // Requête de tous les documents dans rankings !
      QuerySnapshot getAll = await FirebaseFirestore.instance.collection('rankings').get();
      getAll.docs.forEach((challenge) {
        //On fetch l'objet avec les données du document
        Map<String, dynamic> data = challenge.data();
        // On récupère ce qu'il faut !
        this.rankings[challenge.id] = data != null ? data : {};
      });
      //print(this.rankings.toString());
      this.isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Erreur : Impossible de charger les classements : ' + e.toString());
    }
  }


  /// *********************************************
  /// Renvoie le bon chemin vers le top 10
  /// *********************************************
  String getTop10Path({String challengeId, dynamic category}) {
    String top10Path = '';
    // Le path est toujours différent en fonction du challenge, donc on crée la chaine de caractères différemment à chaque fois.
    switch (challengeId) {

      /// Il faut que category soit un objet avec les propriétés key et time (G2 / 1min par exemple)
      case 'note_rush':
        // Extraction des variables pour que ce soit plus simple ensuite
        String key = category != null && category['key'] != null ? category['key'] : 'G2';
        String time = category != null && category['time'] != null ? category['time'] : '1min';
        top10Path += key + '_' + time + '_top10';
        break;

      default:
        print('mdr');
    }
    return top10Path;
  }



  /// *********************************************
  /// Enregistre un nouveau score, et vérifie s'il faut le mettre dans le top 10. Renvoie le numéro dans le classement si c'est le cas (0 sinon)
  /// *********************************************
  Future<int> saveScore({String challengeId, dynamic category, int score, dynamic stats, String username, bool isNewPB}) async {

    int classement = 0;

    try {
      // Enregistrement du score dans la bonne sous collection (avec le mois et l'année)
      DateTime now = new DateTime.now();
      String subCollectionPath = now.month.toString() + '_' + now.year.toString();

      // On crée l'object qui sera utilisé pour les insert dans la base
      Map<String, dynamic> resultObject = {
        'userId': FirebaseAuth.instance.currentUser.uid,
        'username': username != null ? username : 'Anon.',
        'category': category,
        'score': score,
        'stats': stats != null ? stats : {},
        'date': now,
      };


      //*************       ENREGISTREMENT BRUT DU SCORE
      DocumentReference scoreDocument = await FirebaseFirestore.instance.collection('rankings').doc(challengeId).collection(subCollectionPath).add(resultObject);
      // On l'ajoute à l'objet du top 10 potentiel
      resultObject['scoreDocumentId'] = scoreDocument.id;


      // Si c'est un nouveau record perso !
      if (isNewPB){
        //*************       RÉCUPERATION DES TOP 10 DE CE CHALLENGE
        // On récup les Rankings du challenge
        DocumentSnapshot challengeRankings = await FirebaseFirestore.instance.collection('rankings').doc(challengeId).get();
        // On les enregistre en local de manière safe
        this.rankings[challengeId] = challengeRankings.data() != null ? challengeRankings.data() : {};

        //*************       CHECK SI TOP 10 OU NON
        String top10Path = getTop10Path(challengeId: challengeId, category: category);
        List<dynamic> top10 = (this.rankings[challengeId][top10Path] != null) ? this.rankings[challengeId][top10Path] : [];

        // On vire le dernier résultat connu de l'utilisateur dans le top 10 (s'il existe)
        top10.removeWhere((result) => result['userId'] == FirebaseAuth.instance.currentUser.uid);


        // L'index est là où le score est plus petit que le score qui vient d'être fait.
        int insertIndex = top10.indexWhere((result) => score > result['score']);

        // Si on est bon dernier (index = -1) , alors on ajoute le résultat à la fin
        if (insertIndex < 0){
            top10.add(resultObject);
        } else {
          // Si on a trouvé un endroit où l'insérer alors on le fait
          top10.insert(insertIndex, resultObject);
        }

        // Si c'est plus un top 10... il perd sa raison d'être (snif)
        if (top10.length > 10) {
          top10.removeLast();
        }
        // On enregistre la position du joueur
        classement = insertIndex + 1;

        // On insère le résultat dans la base de données
        await FirebaseFirestore.instance.collection('rankings').doc(challengeId).update({top10Path: top10});
        // Changement interne :
        this.rankings[challengeId][top10Path] = top10;
        notifyListeners();
      }


    } catch (e) {
      print('Erreur : Impossible de sauvegarder le score : ' + e.toString());
    }

    //print(classement);
    return classement;
  }

  /// *********************************************
  /// Envoie les infos du joueur à la position passée en argument (ou null si aucun joueur n'est à cette place)
  /// *********************************************
  Map<String, dynamic> getRankedUser({String challengeId, int rank, dynamic category}) {
    String top10Path = getTop10Path(challengeId: challengeId, category: category);
    // SI le chemin existe  et qu'on déborde pas des limite du tableau.
    if (this.rankings[challengeId][top10Path] != null && this.rankings[challengeId][top10Path].length >= rank) {
      return {
        'userId': this.rankings[challengeId][top10Path][rank - 1]['userId'],
        'username': this.rankings[challengeId][top10Path][rank - 1]['username'],
        'score': this.rankings[challengeId][top10Path][rank - 1]['score'],
      };
    }
    // Sinon on retourne null car on a fait une betise (ou rien n'existe)
    return null;
  }



} // Fin de la classe
