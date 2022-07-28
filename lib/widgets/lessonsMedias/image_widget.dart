import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
    // S'il y a du padding, on le récupère
    double padding = media['padding'] != null ? media['padding'].toDouble() : 0.0;

    // Si le fit existe, et si l'alignement existe ...
    BoxFit imgFit = (media['fit'] != null && IMG_FIT[media['fit']] != null) ? IMG_FIT[media['fit']] : BoxFit.cover; // BoxFit.scaleDown
    Alignment imgAlign = (media['align'] != null && IMG_ALIGN[media['align']] != null) ? IMG_ALIGN[media['align']] : Alignment.center;

    // Un petit fix : S'il y a du padding alors on doit afficher l'image en entier pour ne pas la couper betement
    imgFit = (padding > 0) ? BoxFit.scaleDown : imgFit;
    print(imgFit.toString());

    // On check si c'est une image d'internet ou interne
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        // On découpe les bords en bas, mais seulement si c'est en zoom !
        borderRadius: (imgFit == BoxFit.cover && padding < 5.0)
            ? BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )
            : BorderRadius.zero,
        // On switch selon le type d'image (logique)
        child: (media['type'] == 'networkImage')
            ? FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: media['src'],
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


    // On check si c'est une image d'internet ou interne
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.red),
      alignment: Alignment.center,
      child: ClipRRect(
        // On découpe les bords en bas, mais seulement si c'est en zoom !
        borderRadius: (imgFit == BoxFit.cover && padding == 0.0)
            ? BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )
            : BorderRadius.zero,
        // On switch selon le type d'image (logique)
        child: (media['type'] == 'networkImage')
            ? Image.network(media['src'], fit: imgFit,
          alignment: imgAlign,)/*FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: media['src'],
          fit: imgFit,
          alignment: imgAlign,
        )*/
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
