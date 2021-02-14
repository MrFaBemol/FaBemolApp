import 'package:FaBemol/data/music.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotesButtons extends StatelessWidget {
  final Function callback;
  String layout;

  NotesButtons(this.layout, this.callback);

  NotesButtons.line(this.callback) {
    this.layout = 'line';
  }

  NotesButtons.circle(this.callback) {
    this.layout = 'circle';
  }

  @override
  Widget build(BuildContext context) {
    switch (this.layout) {
      case 'line':
        return NotesButtonsLine(callback);
        break;

      case 'circle':
        return Transform.scale(scale: 1,child: NotesButtonsCircle(callback));
    }
    return Container();
  }
}

/// *********************************************
/// Les boutons en cercle
/// *********************************************
class NotesButtonsCircle extends StatelessWidget {
  final Function callback;

  NotesButtonsCircle(this.callback);

// Les coordonnées que pour le moment on code en dur. Peut-être essayer plus tard de calculer en fonction de la taille du widget
  final Map<String, Map<String, double>> notesPos = {
    'C': {'top': -0.3, 'left': 0.66},
    'D': {'top': 0.06, 'left': 1.44},         // left 0.78 de diff
    'E': {'top': 0.9, 'left': 1.62},            // left 0.96 de diff
    'F': {'top': 1.55, 'left': 1.08},
    'G': {'top': 1.55, 'left': 0.26},
    'A': {'top': 0.9, 'left': -0.3},
    'B': {'top': 0.06, 'left': -0.12},
  };

  @override
  Widget build(BuildContext context) {
    /*592.0
    360.0

    683
     411
    */
    // MediaQuery.of(context).size.height/ 8.7

    // Un semblant de calcul en proportion pour les petits écrans...
    double addedRadius = (MediaQuery.of(context).size.height - 592) / 3;
    double radius = 70 + addedRadius;
    double moreMargin = radius * 0.70;

    return Container(
      // On ajoute un peu de marge artificiellement. (mieux controlable)
      width: radius*2 + moreMargin,
      height: radius*2 + moreMargin,
      //color: Colors.red,
      child: Center(
        child: Stack(
          overflow: Overflow.visible,
          children: [
            // La bordure, @todo: il faut trouver un moyen de l'afficher sans avoir le ontap désactivé
            /*
            CircleAvatar(
              minRadius: radius+1,
              maxRadius: radius+1,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
              // L'intérieur
              child: CircleAvatar(
                minRadius: radius,
                maxRadius: radius,
                backgroundColor: Colors.white,
              ),
            ),
             */





            // On affiche toutes les notes
            ...MUSICDATA.NOTES_ORDER.map((noteCode) {
              double xPos = radius * notesPos[noteCode]['left'];
              double yPos = radius * notesPos[noteCode]['top'];
              String noteName = MUSICDATA.NOTES_NAMES[noteCode];
              return Positioned(
                top: yPos + moreMargin/2,
                left: xPos + moreMargin/2,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: (){callback(noteCode);},
                    child: NoteCircle(noteName, radius/3),
                  ),
                ),
              );
            }).toList(),


          ],
        ),
      ),
    );
  }
}

// Facilite l'affichage du layout en cercle
class NoteCircle extends StatelessWidget {
  final String name;
  final double radius;

  NoteCircle(this.name, this.radius);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      minRadius: radius+3,
      maxRadius: radius+3,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
      child: CircleAvatar(
        minRadius: radius+2,
        maxRadius: radius+2,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          minRadius: radius,
          maxRadius: radius,
          backgroundColor: Theme.of(context).accentColor,
          child: AutoSizeText(
            name,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: radius-10),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

/// *********************************************
/// Les boutons en ligne
/// *********************************************
class NotesButtonsLine extends StatelessWidget {
  final Function callback;

  NotesButtonsLine(this.callback);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: MUSICDATA.NOTES_ORDER.map((noteCode) {
        return Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              callback(noteCode);
            },
            child: Container(
              height: MediaQuery.of(context).size.width / 7,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                //border: noteCode != 'B' ? Border(right: BorderSide(color: Colors.white)) : null,
                border: Border.all(color: Colors.white, width: 0.5),
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).accentColor,
              ),
              //color: Colors.red,
              child: Text(
                MUSICDATA.NOTES_NAMES[noteCode],
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
