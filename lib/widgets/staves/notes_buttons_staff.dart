import 'dart:math';

import 'package:FaBemol/data/models/musicKey.dart';
import 'package:FaBemol/data/models/musicNote.dart';
import 'package:FaBemol/data/models/musicStaff.dart';
import 'package:FaBemol/widgets/notes_buttons_layouts.dart';
import 'package:flutter/material.dart';

/// *********************************************
/// Une portée qui s'actualise automatiquement quand toutes les notes sont trouvées
/// *********************************************
class NotesButtonsStaff extends StatefulWidget {
  final int notesQuantity;
  final MusicKey musicKey;
  final Function(int) onFinish;
  final Function(bool) onClick;
  final String layout;

  NotesButtonsStaff({this.notesQuantity = 5, this.onFinish, this.onClick, this.musicKey, this.layout = 'circle'});

  @override
  _NotesButtonsStaffState createState() => _NotesButtonsStaffState();
}

class _NotesButtonsStaffState extends State<NotesButtonsStaff> {
  MusicStaff staff;
  List<MusicNote> notes;

  int answerIndex = 0;
  int goodAnswers = 0;

  @override
  void initState() {
    super.initState();
    // Les notes de la portée sont générées
    this.notes = generateNotes(quantity: widget.notesQuantity);
    // La portée en question
    this.staff = MusicStaff(
      notes: this.notes,
      key: widget.musicKey,
      scale: 1,
      closeNotes: true,
      //bgColor: Colors.white
    );
    // On récup le nom des notes
    this.staff.generateNotesNames();
  }

  @override
  Widget build(BuildContext context) {
    this.notes[answerIndex].setColor(Colors.lightBlueAccent);

    //return this.staff.render();

    return Column(
      children: [
        this.staff.render(),
        SizedBox(height: 10),
        NotesButtons(widget.layout, addAnswer),
      ],
    );
  }


  /// *********************************************
  /// Le callback quand on clique sur un bouton
  /// *********************************************
  void addAnswer(String answer) {
    // On check la réponse et on l'enregistre
    bool isCorrect = this.staff.notesNames[answerIndex] == answer;
    // On l'envoie au widget parent (le screen du jeu) via le callback onclick
    widget.onClick(isCorrect);
    setState(() {
      this.goodAnswers += isCorrect ? 1 : 0;
      // On met à jour la note avec la bonne couleur selon la réponse
      this.notes[answerIndex].setColor(isCorrect ? Colors.green : Colors.red);
      this.notes[answerIndex].setOpacity(0.3);
      this.answerIndex++;

      // Si toutes les notes actuelles sont passées, on envoie le nombre de bonnes réponses de la série
      if (answerIndex == notes.length) {
        widget.onFinish(this.goodAnswers);
        newSerie();
      }
    });
  }

  /// *********************************************
  /// Initialise les variable pour créer une nouvelle série
  /// *********************************************
  void newSerie() {
    this.answerIndex = 0;
    this.goodAnswers = 0;
    this.notes = generateNotes(quantity: widget.notesQuantity);
    this.staff.setNotes(this.notes);
    this.staff.generateNotesNames();
  }

  /// *********************************************
  /// Génère des notes aléatoirement
  /// *********************************************
  List<MusicNote> generateNotes({
    int quantity = 3,
    int minInterval = 1,
    int maxInterval = 5,
    double minLimit = -1,
    double maxLimit = 7,
  }) {
    Random rng = new Random();
    List<MusicNote> notes = [];
    double nextNote = rng.nextInt(maxLimit.toInt() * 2).toDouble() / 2;
    double changeDirection;
    double change;

    // On ajoute un certain nombre de notes
    for (int i = 0; i < quantity; i++) {
      notes.add(MusicNote(height: nextNote));
      // On calcule l'amplitude, ainsi que si on monte ou on descend
      change = (rng.nextInt(maxInterval).toDouble() + 1) / 2;
      changeDirection = rng.nextBool() ? 1 : -1;
      // On check si on dépasse pas les limites, et on recalcule si cela arrive
      while (nextNote + (change * changeDirection) > maxLimit || nextNote + (change * changeDirection) < minLimit) {
        change = rng.nextInt(maxInterval + 1).toDouble() / 2;
        changeDirection = rng.nextBool() ? 1 : -1;
      }
      nextNote += (change * changeDirection);
    }
    return notes;
  }
}
