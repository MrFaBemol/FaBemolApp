import 'package:flutter/material.dart';

class MusicKey {
  // Les lignes de clé par défaut
  static const Map<String, int> DEFAULT_KEYLINES = {
    'G': 2,
    'F': 4,
    'C': 3,
  };
  // Les lignes de clé par défaut
  static const Map<String, int> DEFAULT_OCTAVE_SOUND = {
    'G': 3,
    'F': 2,
    'C': 3,
  };

  // Les variables de la clé
  final String keyType;
  final Color color;
  final int line;

  MusicKey({
    this.keyType = 'G',
    this.color = Colors.black,
    this.line = 0,
  });

  double get width {
    return getSize();
  }


  /// *********************************************
  /// Renvoie un widget qui affiche la clé sur un stack
  /// *********************************************
  Widget render() {
    return Positioned(
      top: getYPosition(),
      left: 0,
      child: Image.asset(
        'assets/images/staff/keys/$keyType.png',
        width: getSize(),
        color: this.color,
      ),
    );
  }

  /// *********************************************
  /// Renvoie une image tout simple
  /// *********************************************
  Widget renderAlone({bool withStaff = true, double height = 90}) {
    // On calcule le path de l'image
    String path = 'assets/images/staff/keys/';
    if (withStaff){
      int linePath = (this.line == 0) ? DEFAULT_KEYLINES[this.keyType] : this.line;   // On check si la line est définie ou non
      path += this.keyType + linePath.toString() + '_staff.png';
    } else {
      path += this.keyType + '.png';
    }

    return Image.asset(
        path,
        color: this.color,
        height: height,
    );
  }

  double getSize() {
    // Des valeurs testées et approuvées !
    if (this.keyType == 'G') return 35.2;
    if (this.keyType == 'F') return 42;
    if (this.keyType == 'C') return 39.8;
    return 0.0;
  }

  double getYPosition() {
    // Ce qu'il faut ajouter pour monter ou descendre d'une ligne
    double oneLineDifference = 12.3;
    // Calcul de la différence selon la ligne de la clé
    int nbLinesDifference = (this.line == 0) ? 0 : this.line - DEFAULT_KEYLINES[this.keyType];
    if (this.keyType == 'G') return 35.5 - (oneLineDifference * nbLinesDifference.toDouble());
    if (this.keyType == 'F') return 53.5 - (oneLineDifference * nbLinesDifference.toDouble());
    if (this.keyType == 'C') return 52.4 - (oneLineDifference * nbLinesDifference.toDouble());
    return 0.0;
  }
}
