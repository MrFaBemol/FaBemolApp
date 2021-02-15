import 'package:FaBemol/providers/lesson.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:FaBemol/functions/localization.dart';

class OrderedCardsWidget extends StatefulWidget {
  final List<dynamic> answersWidget;

  OrderedCardsWidget({this.answersWidget});

  @override
  _OrderedCardsWidgetState createState() => _OrderedCardsWidgetState();
}

class _OrderedCardsWidgetState extends State<OrderedCardsWidget> {
  // Le tableau pour enregistrer les réponses
  Map<int, int> answers = {};

  // Les draggable générés qu'on garde dans un coin
  Map<int, Widget> answersCardsMap = {};

  // Les dragtarget générés qu'on garde dans un coin
  Map<int, Widget> answersTargetMap = {};

  // L'ordre des question qui va se faire shuffle au début (et du coup on garde la map bien ordonnée)
  List<int> answersList = [];

  @override
  void initState() {
    super.initState();
    resetAnswers(reload: false);
    generateAnswersMap(widget.answersWidget);
    generateAnswersTargetMap();
  }

  @override
  Widget build(BuildContext context) {
    // On parcourt les index des questions dans l'ordre qui a été généré
    List<Widget> answersCardsWidget = generateCardsWidgets();
    List<Widget> answersTargetWidget = generateTargetWidgets();

    //print(answers.toString() + ' => ' + answersList.toString());

    // Toute la partie provider et callback.
    Lesson lessonProvider = Provider.of<Lesson>(context, listen: false);

    //print(answers);
    // On crée la fonction de callback
    Function callback = () {
      int goodAnswers = 0;

      answers.forEach((key, answer) {
        goodAnswers += (key == answer) ? 1 : 0;
      });

      // S'il n'y a pas assez de bonnes réponses
      if (goodAnswers < answers.length) {
        lessonProvider.setCallbackCheck(false);
        lessonProvider.showSnackBar('number_good_answers'.tr() + ' : $goodAnswers / ' + answers.length.toString());
      } else {
        lessonProvider.setCallbackCheck(true);
      }
    };
    // On set la fonction
    lessonProvider.setCallbackFunction(callback);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // On parcourt la liste des réponses possibles qui ont été mélangées
          children: answersCardsWidget,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: answersTargetWidget,
        ),
        SizedBox(height: 20),
        OutlinedButton(onPressed: resetAnswers, child: Text('button_reset'.tr())),
      ],
    );
  }

  /// FIN DU BUILD

  //********************************************************************************************************
  void resetAnswers({bool reload = true}) {
    answers = {};
    for (int i = 1; i < widget.answersWidget.length + 1; i++) {
      answers[i] = null;
    }
    if (reload) setState(() {});
  }

  // Annule une des réponses données.
  // est appelé quand l'utilisateur clique sur une de ses réponses.
  // Ex : je veux supprimer des réponses les valeurs égales à index (normalement il n'y en a qu'une seule maximum)
  void resetSingleAnswer(int index) {
    // L'index est en fait le numéro de réponse, pas l'emplacement. Du coup on parcourt le tableau et on enlève l'endroit où la réponse est égale à index
    setState(() {
      answers.forEach((key, value) {
        if (value == index) {
          answers[key] = null;
        }
      });
    });
  }

  // Génère une map de Widget qui sera éventuellement utilisé ensuite
  // On les a a dispo, et ensuite on les dispose comme on veut à chaque rebuild
  void generateAnswersMap(List<dynamic> answersWidget) {
    // On génère les petites boites et on les met dans une map
    for (int i = 1; i < answersWidget.length + 1; i++) {
      Widget widget = answersWidget[i - 1]['widget'];
      String label = answersWidget[i - 1]['label'] != null ? answersWidget[i - 1]['label'] : '';
      // Ici on insère le draggable dans la map avec son index (de 1 à 4)
      answersCardsMap[i] = InkWell(
        onTap: () {
          resetSingleAnswer(i);
        },
        child: Draggable<int>(
          data: i,
          child: DraggableCard(child: widget, label: label),
          feedback: DraggableCard(
            child: widget,
            shadow: true,
            label: label,
          ),
          // Renvoie un place holder gris
          childWhenDragging: DraggableCard(
            isSupport: true,
            child: Opacity(
              opacity: 0.2,
              child: widget,
            ),
          ),
        ),
      );
      // On ajoute la réponse à la liste des réponses sous forme d'index
      answersList.add(i);
    }
    // On mélange bien le tout
    answersList.shuffle();
  }

  // Génère une map de Widget qui sera éventuellement utilisé ensuite
  // On les a a dispo, et ensuite on les dispose comme on veut à chaque rebuild
  void generateAnswersTargetMap() {
    for (int i = 1; i < widget.answersWidget.length + 1; i++) {
      answersTargetMap[i] = DragTarget<int>(
        builder: (BuildContext context, List<int> incoming, List rejected) {
          return Opacity(
            opacity: 0.8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: Text(i.toString()),
            ),
          );
        },
        onAccept: (answer) {
          setState(() {
            resetSingleAnswer(answer);
            answers[i] = answer;
          });
        },
      );
    }
  }

  // Génère la bonne liste de widgets qui seront affichés sur la première ligne
  List<Widget> generateCardsWidgets() {
    return answersList.map((i) {
      // Si la réponse est déja enregistrée
      return (answers.values.contains(i))
          // on n'affiche pas la card mais juste un placeholder gris
          ? DraggableCard(isSupport: true)
          // Sinon c'est bien la card
          : answersCardsMap[i];
    }).toList();
  }

  // Génère la bonne liste de widgets qui seront affichés sur la deuxième ligne
  List<Widget> generateTargetWidgets() {
    List<Widget> answersTargetWidgets = [];
    // On parcourt les dragtarget dans l'ordre de 1 à 4
    answersTargetMap.forEach((i, target) {
      if (answers[i] == null) {
        // Si la réponse de cet index n'a pas encore été donné, on affiche la target.
        answersTargetWidgets.add(target);
      } else {
        // Sinon on affiche la draggable card correspondant à la réponse qui a été donnée
        answersTargetWidgets.add(answersCardsMap[answers[i]]);
      }

      /*// Liste des widget dans le stack renvoyé
      List<Widget> stackWidgetsList = [];
      // Si on a une réponse, on l'affiche
      if (answers[i] != null) stackWidgetsList.add(answersCardsMap[answers[i]]);
      // DAns tous les cas on affiche la target
      stackWidgetsList.add(target);

      answersTargetWidgets.add(Stack(
        children: stackWidgetsList,
      ));*/
    });
    return answersTargetWidgets;
  }
}

class DraggableCard extends StatelessWidget {
  final Widget child;
  final bool shadow;
  final bool isSupport;
  final String label;

  DraggableCard({Key key, this.child, this.isSupport = false, this.shadow = false, this.label = ''}) : super(key: key);

  // L'ombre qu'on affiche (ou non)
  final BoxShadow shadowBox = BoxShadow(
    color: Colors.black54,
    spreadRadius: 3,
    blurRadius: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
              color: (isSupport) ? Colors.grey[200] : Colors.white,
              boxShadow: (this.shadow) ? [shadowBox] : [],
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: (isSupport) ? null : Border.all(color: Colors.black54)),
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: child != null ? child : Text(''),
        ),
        // Si ce n'est pas le support et qu'il y a un texte à afficher
        if (!isSupport && label != '')
          AutoSizeText(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
      ]),
    );
  }
}
