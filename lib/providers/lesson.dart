//import 'dart:js';

import 'package:FaBemol/widgets/lessonsMedias/audio_player_widget.dart';
import 'package:FaBemol/widgets/lessonsMedias/ordered_cards_widget.dart';
import 'package:FaBemol/widgets/lessonsMedias/staff_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

// Pour le painter, il faut pouvoir utiliser le controller et enregistrer l'image
import 'package:painter/painter.dart';

// Les widgets de merde qui cassent les couilles
import 'package:FaBemol/widgets/lessonsMedias/image_widget.dart';
import 'package:FaBemol/widgets/lessonsMedias/painter_widget.dart';

class Lesson with ChangeNotifier {
  String catId;
  String lessonId;
  String title;
  String description;
  String icon;
  int difficulty;
  int cost;

  List<dynamic> steps;

  /// Le getter pour le nombre total d'étapes
  int get numberOfSteps {
    return steps.length;
  }

  //****************************************** La clé et le context qui permet d'utiliser tout le material
  GlobalKey<ScaffoldState> _scaffoldKey;
  BuildContext _context;

  // Ici on peut accéder / modifier à la clé du scaffold et au context de la page
  void setKey(GlobalKey<ScaffoldState> key) {
    this._scaffoldKey = key;
  }

  void setContext(BuildContext context) {
    this._context = context;
  }

  GlobalKey<ScaffoldState> get scaffoldKey {
    return _scaffoldKey;
  }

  BuildContext get context {
    return _context;
  }

  // **********************************************************************  Les infos du callback :
  // La fonction est éxécutée quand on passe à l'étape suivante.
  Function callback = () {};

  // Cette variable doit être modifiée dans la fonction de  callback
  bool callbackCheck = true;

  void setCallbackFunction(Function f) {
    this.callback = f;
  }

  void setCallbackCheck(bool check) {
    this.callbackCheck = check;
  }

  // Exécute la fonction de callback, puis renvoie le résultat.
  bool nextStep() {
    this.callback();
    return callbackCheck;
  }

  // Réinitialise le callbackCheck à true, pour éviter d'être bloqué
  void previousStep() {
    this.callback = () {};
    this.callbackCheck = true;
  }

  void showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      duration: Duration(seconds: 1),
      backgroundColor: Theme.of(_context).accentColor,
    ));
  }

  /// ****************************************************************************************************************************************
  /// Récupère la leçon depuis la base de données
  /// *********************************************
  Future<void> loadLessonFromDB(String catId, String lessonId) async {
    this.callback = () {};
    this.callbackCheck = true;
    try {
      DocumentSnapshot lesson = await FirebaseFirestore.instance.collection('categories').doc(catId).collection('lessons').doc(lessonId).get();

      print('recup de la leçon');

      if (lesson.exists) {
        // On récupère la langue de l'utilisateur
        String lang = translator.currentLanguage;
        String defaultLang = 'fr';

        Map<String, dynamic> lessonData = lesson.data();
        //print("OK : " + lessonData.toString());

        this.catId = catId;
        this.lessonId = lesson.id;
        this.title = lessonData['title'][lang] != null ? lessonData['title'][lang] : lessonData['title'][defaultLang];
        this.description = lessonData['description'][lang] != null ? lessonData['description'][lang] : lessonData['description'][defaultLang];
        this.icon = lessonData['icon'];
        this.difficulty = lessonData['difficulty'];
        this.cost = lessonData['cost'];

        this.steps = lessonData['steps'];
        notifyListeners();
      }
    } catch (err) {
      print(err);
    }
  } // Fin de LoadLessonFromDB *****************

  ///************************************************************************************************************************************ les getters des infos
  /// Renvoie le texte de l'étape en cours dans la bonne traduction
  /// Attends : le currentStep est celui affiché, donc il démarre à 1 et il faut le décrémenter
  String getStepText(int currentStep) {
    if (steps[currentStep - 1]['text'][translator.currentLanguage] != null) {
      return steps[currentStep - 1]['text'][translator.currentLanguage];
    }
    return "Erreur : Traduction non disponible";
  }

  /// Renvoie les infos sur l'audio
  /// Attention : le currentStep est celui affiché, donc il démarre à 1 et il faut le décrémenter
  Map<String, String> getStepAudio(int currentStep) {
    if (steps[currentStep - 1]['audio'] != null) {
      //@todo ; gérer l'extraction des données
      //les infos de l'audio
      return {'test': 'test'};
    }
    return null; // équivalent à return null mais pour un widget
  }

  ///******************************************************************************
  ///   Renvoie le media de l'étape en cours, ou le média précédent le plus proche.
  ///   Encore une fois, le currentStep part de 1 donc on doit enlever 1 à l'index
  Widget getStepDisplay(int currentStep) {
    // On parcourt les display à reculons
    for (int i = currentStep - 1; i >= 0; i--) {
      // Si le le display existe
      if (steps[i]['display'] != null) {
        // On récup les infos des médias qui seront dans le display
        // Le véritable type est : List<Map<String, dynamic>>
        // Mais obligation d'utiliser List<dynamic>
        List<dynamic> medias = steps[i]['display'];

        // S'il n'y a qu'un média on le renvoie tout de suite, ez ez ez
        if (medias.length == 1) {
          return getMediaWidget(medias[0]);
        }
        // S'il y a plus d'un widget il faut ordonner le layout
        else if (medias.length > 1) {
          // On liste les différents widgets dans l'ordre
          List<Widget> mediaWidgets = medias.map((media) => getMediaWidget(media)).toList();
          // Pour l'instant, gestion uniquement de row / column
          // Défaut = Row
          String layoutType = (steps[i]['displayLayout'] != null) ? steps[i]['displayLayout'] : 'row';
          if (layoutType == 'row') {
            return Row(
              children: [
                ...mediaWidgets.map((widget) {
                  return Expanded(flex: 1, child: widget); // Ils ont tous la même largeur
                }).toList()
              ],
            );
          } else if (layoutType == 'column') {
            return Column(
              children: [
                ...mediaWidgets.map((widget) {
                  return Expanded(flex: 1, child: widget); // Ils ont tous la même hauteur
                }).toList()
              ],
            );
          }
        }
        // Pour l'instant on ne gère pas plusieurs médias
        return Text('Erreur : pas de gestion de média multiples');
      }
    }
    // Phrase qui ne s'affiche normalement jamais s'il y a un média à afficher dans l'étape 1 !
    return Text("Erreur : pas de média disponible");
  }

  ///************************************************************************************************************************************************ Les getters des médias
  /// Renvoie le Widget correspondant au Media passée en argument
  Widget getMediaWidget(dynamic media) {
    // Ici on check le type de media
    switch (media['type']) {
      // Dans les 2 cas possible d'une image
      case 'networkImage':
        return imageMedia(media);
        break;
      case 'assetImage':
        return imageMedia(media);
        break;

      case 'staff':
        return staffMedia(media);
        break;

      // Painter
      case 'painter':
        return painterMedia(media);
        break;
      case 'lastPainterResult':
        return lastPainterResult;
        break;

      case 'orderedCards':
        return orderedCardsMedia(media);
        break;

      case 'audioPlayer':
        return audioPlayerMedia(media);
        break;

      // Un tableau blanc
      case 'blank':
        return Container();
        break;

      // Affiche une erreur car le type de média n'est pas reconnu
      default:
        return Text('Erreur : type de média non reconnu (' + media['type'] + ')');
    }
  }

  // Renvoie une image avec les bons paramètres
  // Pas la fonction la plus utile, mais permet de dégager toutes les constantes de merde de ce fichier.
  Widget imageMedia(dynamic media) {
    return ImageWidget(media: media);
  }

  // Renvoie une portée avec les bons paramètres
  Widget staffMedia(dynamic media) {
    return StaffWidget(media: media);
  }

  Widget audioPlayerMedia(dynamic media) {
    return AudioPlayerWidget(media: media);
  }

  /// *********************************************
  /// Renvoie des cartes ordonnées interactives
  /// *********************************************
  Widget orderedCardsMedia(dynamic media) {
    // La liste de widget qu'on va créer pour les cartes
    List<dynamic> answersList = [];
    // La liste des réponses qu'on extrait de la DB
    List<dynamic> answers = media['answers'];
    // On parcourt les réponses de la DB
    answers.forEach((answer) {
      // Si on a rien de défini, autant ne pas afficher
      if (answer['type'] == 'none' || answer['type'] == '' || answer['type'] == null) {
        return;
      }

      Widget widget;
      if (answer['type'] == 'text') {
        // Si on a affaire à un texte
        // @todo: gérer plusieurs langues dans les cards (pas hyper urgent)
        widget = AutoSizeText(
          answer['value'],
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'NerkoOne', fontSize: 18),
        );
      } else if (answer['type'] == 'assetImage') {
        // Si c'est une assetImage
        widget =
            ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/images/lessons/' + answer['value'], fit: BoxFit.scaleDown, alignment: Alignment.center));
      } else {
        // SI c'est une image du network
        widget = ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(answer['value'], fit: BoxFit.scaleDown, alignment: Alignment.center));
      }
      // On a joute enfin le widget dans notre liste
      answersList.add({
        'widget': widget,
        'label': answer['label'] != null ? answer['label'] : '',
      });
    });
    // On renvoie les cartes !
    return OrderedCardsWidget(
      answersWidget: answersList,
    );
  }

  /// *********************************************
  /// Un painter sur lequel on peut écrire
  /// Important surtout pour le callback !
  /// *********************************************
  Widget painterMedia(dynamic media) {
    // On crée le controller qu'on va passer en argument
    PainterController controller = new PainterController();
    // On définit la largeur selon les infos de la DB ou par défaut
    controller.thickness = (media['thickness'] != null) ? media['thickness'] : 5.0;
    // Idem pour définir la couleur de fond de l'image (un petit gris pas piqué des hannetons)
    controller.backgroundColor = Colors.grey[100].withOpacity(0.2); // @ todo : pouvoir choisir la couleur

    // Renvoie un widget avec painter + des boutons
    return PainterWidget(controller: controller);
  } // Fin de painterMedia

  //**************************************************
  // Ici on s'occupe du dernier dessin de l'utilisateur.
  Widget lastPainterResult = Container();

  // Appelée depuis le PainterWidget dans la fonction de callback
  void setLastPainterResult(Widget result) {
    this.lastPainterResult = result;
  }
} // Fin de la classe Lesson
