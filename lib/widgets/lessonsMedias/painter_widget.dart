import 'dart:typed_data';

import 'package:FaBemol/providers/lesson.dart';
import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'package:provider/provider.dart';
import 'package:FaBemol/functions/localization.dart';

class PainterWidget extends StatelessWidget {

  final PainterController controller;

  PainterWidget({this.controller});



  @override
  Widget build(BuildContext context) {

    Lesson lessonProvider = Provider.of<Lesson>(context, listen: false);

    // La GROSSE fonction appelée quand on passe à la prochain étape
    // D'abord on gère s'il n'y a rien de dessiné
    // Puis on enregistre l'image dans une variable
    Function callback = () {
      // S'il n'y a rien de dessiné sur le painter
      if (controller.isEmpty) {
        lessonProvider.setCallbackCheck(false);
        lessonProvider.showSnackBar('error_painter_empty'.tr());
        return;
      }

      // On enregistre l'image dans la variable dédiée.
      Widget lastPainterResult = FutureBuilder<Uint8List>(
        future: controller.finish().toPNG(),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Image.memory(
              snapshot.data,
              fit: BoxFit.contain,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      );

      // On envoie le résultat au provider
      lessonProvider.setLastPainterResult(lastPainterResult);
      // IMPORTANT pour dire qu'on peut passer à l'étape suivante
      lessonProvider.setCallbackCheck(true);
    };

    // On envoie la fonction au provider
    lessonProvider.setCallbackFunction(callback);

    return Stack(
      children: [
        // Le painter principal
        Painter(controller),
        //Les boutons à afficher en bas à droite
        Positioned(
          bottom: 1,
          right: 1,
          child: Row(
            children: [
              // Le bouton pour effacer la dernière action
              IconButton(
                  icon: Icon(Icons.undo),
                  onPressed: () {
                    if (!controller.isEmpty) {
                      controller.undo();
                    }
                  }),
              // Le bouton pour supprimer
              IconButton(
                icon: new Icon(Icons.delete),
                onPressed: controller.clear,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
