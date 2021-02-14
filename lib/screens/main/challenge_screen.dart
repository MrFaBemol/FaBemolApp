
import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/widgets/challenge/note_rush_challenge_card.dart';
import 'package:flutter/material.dart';

class ChallengeScreen extends StatefulWidget {
  static const String routeName = '/challenge';

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [

          NoteRushChallengeCard(),

          // ...DATA.CHALLENGES_CATEGORIES.entries.map((cat) => ChallengeCategoryCard(cat.key, cat.value)),
        ],
      ),
    );
  }
}

/*

Map<String, dynamic> lesson = {
  'title': {
    'fr': 'Leçon de test',
    'en': 'Test Lesson',
  },
  'description': {
    'fr':
    'Une petite description histoire de tester, mais rien de bien méchant!',
    'en': 'A small test description, but nothing to worry about!',
  },
  'difficulty': 1,
  'cost': 1,
  'icon': 'etudiant.png',
  'steps': [
    {
      'text': {
        'fr': 'Ceci est la première étape',
        'en': 'This is the first step !'
      },
    },
    {
      'text': {
        'fr': 'Ceci est la deuxième étape',
        'en': 'This is the second step !',
      }
    },
    {
      'text': {
        'fr': "Et la 3è! Fiouu c'était long!",
        'en': 'Finally the 3rd! That was a long journey!'
      }
    }
  ]
};




@override
Widget build(BuildContext context) {
  return Center(
    child: Container(
      child: ElevatedButton(
        child: Text("ENVOYER LES DONNÉES"),
        onPressed: () async {
          return ;
          // Envoie de la structure
          return FirebaseFirestore.instance
              .collection('categories')
              .doc('c1_notation')
              .collection('lessons')
              .add(lesson)
              .then((value) => print("Add OK, id : "+ value.id))
              .catchError((error) => print("Add FAILED"));
        },
      ),
    ),
  );
}
*/
