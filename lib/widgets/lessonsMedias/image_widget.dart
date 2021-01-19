import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {

  //************************************************************
  // QUelques équivalences, histoire de pouvoir décider de ça depuis la base de données...
  static const Map<String, BoxFit> IMG_FIT = {
    'zoom': BoxFit.cover,
    'full': BoxFit.contain,
  };
  static const Map<String, Alignment> IMG_ALIGN = {
    'center': Alignment.center,
    'topCenter': Alignment.topCenter,
    'bottomCenter': Alignment.bottomCenter,
    'centerRight': Alignment.centerRight,
    'centerLeft': Alignment.centerLeft,
    'topLeft': Alignment.topLeft,
    'topRight': Alignment.topRight,
    'bottomLeft': Alignment.bottomLeft,
    'bottomRight': Alignment.bottomRight,
  };

  final dynamic media;

  ImageWidget({this.media});


  @override
  Widget build(BuildContext context) {
    // Si le fit existe, et si l'alignement existe ...
    BoxFit imgFit = (media['fit'] != null && IMG_FIT[media['fit']] != null)
        ? IMG_FIT[media['fit']]
        : BoxFit.scaleDown;
    Alignment imgAlign =
    (media['align'] != null && IMG_ALIGN[media['align']] != null)
        ? IMG_ALIGN[media['align']]
        : Alignment.center;

    // On check si c'est une image d'internet ou interne
    return (media['type'] == 'networkImage')
        ? Image.network(
      media['src'],
      fit: imgFit,
      alignment: imgAlign,
    )
        : Image.asset(
      'assets/images/lessons/' + media['src'],
      fit: imgFit,
      alignment: imgAlign,
    );
  }
}
