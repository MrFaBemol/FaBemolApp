import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {

  /// *********************************************
  /// Obligatoire :
  ///   - src : L'url du fichier source ou le path dans les assets
  ///
  /// Optionnel:
  ///   - fit: 'zoom' (remplit le display) / 'full' (l'image est entièrement visible quoi qu'il arrive)
  ///   - align: même "string" que dans Alignement.XXXXXXX
  /// *********************************************
  final dynamic media;
  ImageWidget({this.media});

  @override
  Widget build(BuildContext context) {
    // Si le fit existe, et si l'alignement existe ...
    BoxFit imgFit = (media['fit'] != null && IMG_FIT[media['fit']] != null) ? IMG_FIT[media['fit']] : BoxFit.scaleDown;
    Alignment imgAlign = (media['align'] != null && IMG_ALIGN[media['align']] != null) ? IMG_ALIGN[media['align']] : Alignment.center;

    // On check si c'est une image d'internet ou interne
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        // On découpe les bords en bas, mais seulement si c'est en zoom !
        borderRadius: (media['fit'] != null && media['fit'] == 'zoom')
            ? BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
            : BorderRadius.zero,
        // On switch selon le type d'image (logique)
        child: (media['type'] == 'networkImage')
            ? Image.network(
                media['src'],
                fit: imgFit,
                alignment: imgAlign,
              )
            : Image.asset(
                'assets/images/lessons/' + media['src'],
                fit: imgFit,
                alignment: imgAlign,
              ),
      ),
    );
  }




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
}
