import 'package:FaBemol/providers/lessons_structure.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/screens/lessons/lessons_list_screen.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:FaBemol/widgets/lessons_category_progression.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class LessonCategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  final String catId;

  LessonCategoryCard(this.catId, this.category);

  @override
  Widget build(BuildContext context) {
    // On récup les infos sur la catégorie
    // Le nombre total de leçons. Renvoie -1 Si la catégorie n'existe pas.
    final int nbTotalLessons = Provider.of<LessonsStructure>(context, listen: false).getNbLessons(this.catId);

    // Si on a pas l'id dans la DB, ou si on a pas de leçons à afficher ... Autant ne rien afficher
    if (nbTotalLessons < 0)
      return Container(
        child: Text('La catégorie $catId n\'existe pas dans la DB'),
      );
    if (nbTotalLessons == 0) return Container();

    // La quantité de leçons terminées par l'utilisateur
    final int nbCompleteLessons = Provider.of<UserProfile>(context).getCompletedLessonsByCategory(this.catId);
    // On calcule la progression
    final double progressionPercentage = (nbTotalLessons == 0) ? 0 : nbCompleteLessons.toDouble() / nbTotalLessons.toDouble();

    // Le container qui sert de bordure
    return ContainerFlatDesign(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      borderRadius: BorderRadius.circular(5),
      // Le dégradé (mais à mettre dans un container si on veut retester)


      // La card principale
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(LessonsListScreen.routeName, arguments: this.catId);
        },
        child: Column(
          children: [


            // ************************************** LA CATEGORIE EN QUESTION
            Container(
              //color: Colors.red,
              margin: EdgeInsets.all(5),
              child: Row(
                children: [
                  //******************** L'icône
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 70,
                    child: Hero(
                      tag: this.catId + '_icon_hero',
                      child: Image.asset(
                        this.category['icon'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //******************* Le titre et le nombre de leçons effectuées
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: this.catId + '_title_hero',
                          child: AutoSizeText(
                            this.category['title'].toString().tr(),
                            style: Theme.of(context).textTheme.headline6,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'lessons'.tr() + ' : $nbCompleteLessons/$nbTotalLessons',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                  ),

                  // ************ LA PROGRESSION
                  Container(
                    padding: EdgeInsets.only(bottom: 0),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: LessonsCategoryProgression(
                      progressionPercentage: progressionPercentage,
                      color: this.category['color'],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
