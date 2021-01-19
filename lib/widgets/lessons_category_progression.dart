import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LessonsCategoryProgression extends StatelessWidget {
  final double progressionPercentage;
  final Color color;

  LessonsCategoryProgression({this.progressionPercentage, this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Si on a terminé toutes les leçons :
        if (progressionPercentage == 1)
          Image.asset(
            'assets/icons/96/medaille.png',
            height: 34,
          ),
        // @todo : changer l'icone pour qq chose de plus gratifiant (trophée ?)

        // S'il reste des leçons on affiche le pourcentage effectués.
        if (progressionPercentage < 1)
          CircularProgressIndicator(
            value: progressionPercentage,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: Colors.grey[200],
          ),
        if (progressionPercentage < 1)
          AutoSizeText(
            ((progressionPercentage * 100).toInt()).toString() + '%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
      ],
    );
  }
}
