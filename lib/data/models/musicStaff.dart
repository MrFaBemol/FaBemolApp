import 'package:FaBemol/data/models/musicKey.dart';
import 'package:FaBemol/data/models/musicNote.dart';
import 'package:FaBemol/data/music.dart';
import 'package:flutter/material.dart';

class MusicStaff {
  MusicKey key;

  /// Les objets MusicNote qu'on va render sur la partition
  List<MusicNote> notes = [];

  /// La liste des noms des notes calculée par rapport à la clé
  List<String> notesNames = [];

  final double scale;
  final Color color;
  final Color bgColor;
  final bool staffDisabled;

  // Utilisée dans les fonctions pour animer
  double animationOffset;

  // Si on veut une portée compacte
  bool closeNotes;

  // Les infos de sons
  String instrument;

  MusicStaff({
    this.notes,
    this.key,
    this.scale = 1,
    this.color = Colors.black,
    this.bgColor,
    this.staffDisabled = false,
    this.animationOffset,
    this.closeNotes = false,
    this.instrument = 'piano',
  });

  void setAnimationOffset(double offset) {
    this.animationOffset = offset;
  }

  void setNotes(List<MusicNote> notes) {
    this.notes = notes;
  }

  Widget render() {
    // On calcule la largeur de l'en-tête de la portée
    double staffHeadWidth = 10;
    staffHeadWidth += this.key != null ? this.key.width : 0;

    // Ici on render la liste des notes
    List<Widget> notesRender = [];
    if (this.notes != null) {
      // La variable qui va permettre de placer les notes horizontalement. On démarre pas à zéro pour pas coller l'entête
      double xOffsetDiff = (this.animationOffset != null) ? this.animationOffset : 8;
      // On parcourt toutes les notes
      for (var i = 0; i < notes.length; i++) {
        // Le render
        notesRender.add(notes[i].render(onStaff: true, xOffsetDiff: xOffsetDiff));
        xOffsetDiff += (closeNotes) ? notes[i].width / 2 : notes[i].width;
      }
    }
    //print(this.scale);
    // Renvoie le widget final
    return Transform.scale(
      // L'échelle
      scale: this.scale,
      alignment: FractionalOffset.topLeft,
      // La surface de la portée avec un espace en haut et en bas pour les lignes supplémentaires
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: this.bgColor != null ? this.bgColor : Colors.white.withOpacity(0),
          //border: Border.all(color: Colors.black54, width: 0.5),
          //borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          overflow: Overflow.clip,
          children: [
            // *************************************** La portée
            if (!this.staffDisabled)
              Positioned(
                left: 0,
                top: 50,
                // Le container  qui répète l'image. On lui donne une grande largeur pour qu'il ne soit jamais emmerdé par la taille de l'écran
                child: Container(
                  width: 3000,
                  height: 60,
                  child: Image.asset(
                    'assets/images/staff/staff_background.png',
                    repeat: ImageRepeat.repeatX,
                    color: Colors.black,
                  ),
                ),
              ),

            // On affiche la clé si elle existe
            if (this.key != null) this.key.render(),

            // Le container des notes avec une marge pour démarrer après la clé / armure / métrique
            Container(
              margin: EdgeInsets.only(left: staffHeadWidth),
              //color: Colors.red[100].withOpacity(0.5),
              child: Stack(
                children: [
                  ...notesRender,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } // RENDER



  /// Génère les noms de toutes les notes pour la clé en cours.
  Map<double, Map<String, dynamic>> notesInfosMap;


  /// *********************************************
  /// Trouve le nom des notes de la partition
  /// *********************************************
  void generateNotesNames() {
    if (this.key == null) return;
    if (this.notesInfosMap == null) generateNotesInfosMap();

    this.notesNames = [];
    notes.forEach((note) {
      // Ajoute le nom à la liste des notes
      this.notesNames.add(notesInfosMap[note.height]['name']);
      // Génère le player audio de la note
      note.setSoundPath(path: notesInfosMap[note.height]['sound'], instrument: this.instrument);
    });
  }

  /// *********************************************
  /// Génère la carte des notes pour cette portée
  /// *********************************************
  void generateNotesInfosMap() {
    //audioCache = new AudioCache();
    this.notesInfosMap = {};
    String noteName;
    // Si on a pas de clé sur la portée
    if (this.key == null) {
      print("ERREUR : Impossible de générer les notes si aucune clef n'est définie !");
      return;
    }
    // On chope le nom de la clé
    String keyType = this.key.keyType;
    // Sa ligne
    double keyLine = this.key.line > 0 ? this.key.line.toDouble() : MusicKey.DEFAULT_KEYLINES[keyType].toDouble();
    // L'octave correspondant au son de la note repère :
    int octaveSound = MusicKey.DEFAULT_OCTAVE_SOUND[keyType];

    List<String> notesOrder = MUSICDATA.NOTES_ORDER;

    // L'index du nom de la clé dans l'ordre
    int keyIndex = notesOrder.indexOf(keyType);
    // On part de la ligne de la clé, et on monte les lignes pour trouver le nom des notes jusqu'à la ligne 10
    for (double i = keyLine; i < 11; i += 0.5) {
      // On monte d'une octave si besoin (à chaque LA)
      noteName = notesOrder[keyIndex];
      if (noteName == 'A') octaveSound++;
      // L'objet enregistré
      notesInfosMap[i] = {
        'name': noteName,
        'sound': noteName + octaveSound.toString(),
      };
      // Si on a atteint la fin du nom des notes, on repart à zéro, sinon on avance
      keyIndex = (keyIndex == notesOrder.length - 1) ? 0 : keyIndex + 1;
    }

    // On fait la même en descendant, donc on repart des repères
    keyIndex = notesOrder.indexOf(keyType);
    octaveSound = MusicKey.DEFAULT_OCTAVE_SOUND[keyType];
    for (double i = keyLine; i > -6; i -= 0.5) {
      // On monte d'une octave si besoin (à chaque LA)
      noteName = notesOrder[keyIndex];
      if (noteName == 'A') octaveSound--;
      notesInfosMap[i] = {
        'name': noteName,
        'sound': noteName + octaveSound.toString(),
      };
      // Si on a atteint la fin du nom des notes, on repart à zéro, sinon on descend
      keyIndex = (keyIndex == 0) ? notesOrder.length - 1 : keyIndex - 1;
    }

    print(this.notesInfosMap);
  }


  /*void playNote({bool isCorrect}) async{
    audioCache.play('sounds/notes/piano/A4.mp3');
  }*/


}
