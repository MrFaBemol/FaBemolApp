import 'dart:math';

import 'package:FaBemol/data/models/musicKey.dart';
import 'package:FaBemol/data/models/musicNote.dart';
import 'package:FaBemol/data/models/musicStaff.dart';
import 'package:FaBemol/widgets/staves/notes_buttons_layouts.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

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

  List<AudioPlayer> clusterSounds = [];
  int nbClusters = 7;
  Random rng = new Random();    // Pour pick  un son au hasard si ya une mauvaise réponse


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
      //bgColor: Colors.red[100]
    );
    // On récup le nom des notes
    this.staff.generateNotesNames();


    // Génère les players des clusters
    for (int i = 0; i < nbClusters ; i++){
      AudioPlayer clusterPlayer = AudioPlayer();
      String path = 'assets/sounds/effects/cluster'+ (i+1).toString() +'.mp3';
      clusterPlayer.setAsset(path);
      clusterSounds.add(clusterPlayer);
    }

  }

  @override
  void dispose() {
    super.dispose();
  }


  /// *********************************************
  /// BUILD
  /// *********************************************
  @override
  Widget build(BuildContext context) {
    // On colore la note en cours avec du bleu
    this.notes[answerIndex].setColor(Colors.lightBlueAccent);


    return Column(
      children: [
        this.staff.render(),
        NotesButtons(widget.layout, addAnswer)
      ],
    );
  }




  /// *********************************************
  /// Le callback quand on clique sur un bouton
  /// *********************************************
  void addAnswer(String answer) {
    // On check la réponse et on l'enregistre
    bool isCorrect = this.staff.notesNames[answerIndex] == answer;
    //this.staff.playNote(isCorrect: isCorrect);
    // On l'envoie au widget parent (le screen du jeu) via le callback onclick
    widget.onClick(isCorrect);
    setState(() {
      this.goodAnswers += isCorrect ? 1 : 0;
      // On met à jour la note avec la bonne couleur selon la réponse
      this.notes[answerIndex].setColor(isCorrect ? Colors.green : Colors.red);
      this.notes[answerIndex].setOpacity(0.3);
      // On joue la note ou un cluster si c'est une mauvaise réponse
      print(isCorrect);
      if (isCorrect){
        this.notes[answerIndex].play(isCorrect: isCorrect);   // isCorrect est inutile, mais on verra si besoin plus tard
      } else {
        // On pick un son au hasard avec un index de 0 à nbClusters-1
        int randIndex = rng.nextInt(nbClusters) ;
        print(randIndex);
        // Reset du son si déjà joué et le joue
        this.clusterSounds[randIndex].seek(Duration.zero);
        this.clusterSounds[randIndex].play();
      }

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
