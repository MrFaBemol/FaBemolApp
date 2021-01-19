import 'package:flutter/material.dart';

class MusicNote {
  static const double STANDARD_WIDTH = 15.2;
  static const double WHOLENOTE_WIDTH = 19.6;

  final double duration;
  final double height;

  Color color;
  Color headColor;
  Color stemColor;
  double opacity;

  MusicNote({
    this.height = 3,
    this.duration = 4,
    this.color = Colors.black,
    this.headColor,
    this.stemColor,
    this.opacity = 1,
  });

  Widget headWidget = Container();
  Widget stemWidget = Container();
  List<Widget> additionalLines = [];

  double get width {
    double width = 0.0;
    // On prend la largeur de base
    width += (this.duration < 4) ? STANDARD_WIDTH : WHOLENOTE_WIDTH;
    // On calcule le ratio en fonction de la durée.
    width += (this.duration > 1) ? (this.duration * 0.8) * 15 : 10;
    return width;
  }

  /// *********************************************
  /// La fonction principale qui renvoie le Widget
  /// *********************************************
  Widget render({double xOffsetDiff = 0.0, bool onStaff = false}) {
    // Ici on crée les éléments de la note.
    this.setHead();
    this.setStem();
    this.setAdditionalLines();

    // Ici on render la note avec la tête, la hampe, et tout le tralala.
    Widget noteWidget = Opacity(
      opacity: this.opacity,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          // La hampe de la note
          stemWidget,
          // Les barres supplémentaires
          ...additionalLines,
          // La tête de la note
          headWidget,
        ],
      ),
    );

    // Si la note doit être render sur une portée, on renvoie un Positioned
    if (onStaff) {
      double yPos = getYPosition();
      return Positioned(
        left: xOffsetDiff,
        top: yPos,
        child: noteWidget,
      );
    } else {
      // Sinon on renvoie la note telle qu'elle !
      return noteWidget;
    }
  }

  /// *********************************************
  /// Renvoie la position Y en fonction de la hauteur de la note sur la portée
  /// *********************************************
  double getYPosition() {
    // La position de base pour que la note soit sur la 3è ligne avec un ajustement minimal pour la ronde
    double thirdLineYPos = (this.duration < 4) ? 73.8 : 73.5;
    // Ce qu'il faut ajouter pour monter ou descendre d'une ligne
    double oneLineDifference = 12.3;
    // On soustrait pour monter et on additionne pour descendre
    return thirdLineYPos - ((this.height - 3) * oneLineDifference);
  }

  /// *********************************************
  /// Permet de changer la couleur après la création
  /// *********************************************
  void setColor(Color color) {
    this.color = color;
  }
  /// *********************************************
  /// Permet de changer l'opacité après la création
  /// *********************************************
  void setOpacity(double opacity){
    this.opacity = opacity;
  }

  /// *********************************************
  /// Crée la tête de la note
  /// *********************************************
  void setHead() {
    // On cherche la bonne tête
    String headPath;
    if (this.duration < 2) {
      headPath = 'full.png';
    } else if (this.duration < 4) {
      headPath = 'empty.png';
    } else {
      headPath = 'whole.png';
    }

    this.headWidget = Image.asset(
      'assets/images/staff/heads/' + headPath,
      // La largeur ajustée selon si c'est une ronde ou pas
      width: (this.duration < 4) ? STANDARD_WIDTH : WHOLENOTE_WIDTH,
      color: (this.headColor != null) ? this.headColor : this.color,
    );
  }

  /// *********************************************
  /// Crée la hampe de la note
  /// *********************************************
  void setStem() {
    if (this.duration < 4) {
      // On enregistre le widget
      Widget stemImageWidget = Image.asset(
        'assets/images/staff/lines/stem.png',
        height: 40,
        color: (this.stemColor != null) ? this.stemColor : this.color,
      );
      // On le positionne en fonction de la hauteur de la note (hampe en bas ou en haut)
      this.stemWidget = (this.height <= 3)
          ? Positioned(
              top: -35,
              right: 0.1,
              child: stemImageWidget,
            )
          : Positioned(
              bottom: -35,
              left: 0.2,
              child: stemImageWidget,
            );
    }
  }

  void setAdditionalLines() {
    // Ce qu'il faut ajouter pour monter ou descendre d'une ligne
    double oneLineDifference = 12.3;
    // Ce qu'il faut ajouter si la note n'est pas sur une ligne (du coup faut tout décaler
    double interLineDifference = (this.height.truncateToDouble() != this.height) ? oneLineDifference / 2 : 0;
    // Si la hauteur est en dessous de la première ligne
    if (this.height <= 0) {
      for (int i = 0; i >= this.height; i--) {
        // On ajoute les barres une par une
        this.additionalLines.add(
              Positioned(
                top: 5.5 + (oneLineDifference * i) - interLineDifference,
                left: -3,
                child: Container(
                  color: (this.headColor != null) ? this.headColor : this.color,
                  width: (this.duration >= 4) ? 25 : 21.5,
                  height: 1.5,
                ),
              ),
            );
      }
    } else if (this.height >= 6) {
      // S'il faut monter, c'est la même boucle mais dans l'autre sens.
      for (int i = 6; i <= this.height; i++) {
        this.additionalLines.add(
              Positioned(
                top: 5.5 + (oneLineDifference * (i - 6)) + interLineDifference,
                left: -3,
                child: Container(
                  color: (this.headColor != null) ? this.headColor : this.color,
                  width: (this.duration >= 4) ? 25 : 21,
                  height: 1.5,
                ),
              ),
            );
      }
    }
  }
}
