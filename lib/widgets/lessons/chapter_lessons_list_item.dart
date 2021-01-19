import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/screens/lessons/lesson_overview_screen.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:provider/provider.dart';
import 'package:FaBemol/providers/lessons_structure.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:FaBemol/functions/localization.dart';

class ChapterLessonsList extends StatelessWidget {
  final String catId;
  final String subCatId;
  final String chapterId;

  ChapterLessonsList(this.catId, this.subCatId, this.chapterId);

  @override
  Widget build(BuildContext context) {
    // On récupère la liste des leçons
    List<dynamic> lessonsList =
        Provider.of<LessonsStructure>(context, listen: false)
            .getLessonsFromChapter(this.catId, this.subCatId, this.chapterId);
    // S'il n'y a aucune leçon on n'affiche tout simplement rien
    if (lessonsList.length == 0) return Container();

    // La liste de widgets qui s'affichera
    List<Widget> lessonsWidgets = [];
    // On parcourt toutes les leçons
    lessonsList.forEach((lesson) {
      // On ajoute le lesson tile (le widget est plus bas dans ce fichier)
      lessonsWidgets.add(LessonTileItem(
        lesson: lesson,
        catId: catId,
      ));
      // Si ce n'est pas la dernière leçon du chapitre, on ajoute un divider
      if (lessonsList.indexOf(lesson) < lessonsList.length-1){
        lessonsWidgets.add(Divider(thickness: 1,color: Theme.of(context).shadowColor,),);
      }
    });

    return Column(
      children: [
        // ***** Le titre du chapitre
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: Text(
            this.chapterId.tr(),
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),

        // Les lessons du chapitre
        ContainerFlatDesign(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: lessonsWidgets,
          ),
        )


      ],
    );
  }
}

//*************************
// LE TILE DE LA LECON
//*************************
class LessonTileItem extends StatelessWidget {
  final dynamic lesson;
  final String catId;

  LessonTileItem({this.lesson, this.catId});

  @override
  Widget build(BuildContext context) {
    final String lessonId = lesson['id'];
    final String lessonTitle =
        (lesson['title'][translator.currentLanguage] != null)
            ? lesson['title'][translator.currentLanguage]
            : lesson['title']['en'];
    final String lessonIcon = lesson['icon'];
    final int lessonDifficulty = lesson['difficulty'];


    bool isCompleted = Provider.of<UserProfile>(context).hasCompletedLesson(
        lessonId); // On listen au cas où la personne valide une leçon

    return Container(
      width: double.infinity,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 10),

      //color: Colors.blue[100],
      child: InkWell(
        // Rends la tile interactive
        onTap: () {
          Navigator.of(context).pushNamed(LessonOverviewScreen.routeName,
              arguments: {'lesson': lesson, 'catId': catId});
        },
        // La tile en question
        child: Row(
          children: [
            //@todo: vérifier qu'on veut charger l'image depuis les assets (peut-être mieux a long terme depuis une url?)
            // L'image avec la transition Hero
            Hero(
              tag: 'icon_$lessonId',
              child: Image.asset(
                'assets/icons/lessons/$lessonIcon',
                height: 65,
              ),
            ),

            SizedBox(width: 10),
            // Espace entre icone et Titre

            // Le titre et la difficulté
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'title_$lessonId',
                    child: AutoSizeText(
                      lessonTitle,
                      style: Theme.of(context).textTheme.headline6,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: 5), // Espace vertical entre les 2 textes
                  Hero(
                    tag: 'difficulty_$lessonId',
                    child: Text(
                      'difficulty$lessonDifficulty'.tr().toUpperCase(),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(width: 10),

            // Si la leçon est déjà terminée par l'utilisateur on affiche un petit laurier
            if (isCompleted)
              Image.asset(
                'assets/icons/96/couronne-de-laurier.png',
                height: 30,
                width: 30,
              ),
            if (!isCompleted) SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}
