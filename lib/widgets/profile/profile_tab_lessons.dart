import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/providers/lessons_structure.dart';
import 'package:FaBemol/widgets/lessons_category_progression.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FaBemol/functions/localization.dart';

class ProfileTabLessons extends StatelessWidget {
  final userProfile;

  ProfileTabLessons(this.userProfile);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Le titre de l'onglet
          AutoSizeText(
            'lessons_progression'.tr(),
            style: Theme.of(context).textTheme.headline6,
            maxLines: 1,
          ),
          SizedBox(height: 10),

          // On parcourt les catégories stockées dans le fichier DATA
          // Il est donc impossible d'ajouter des catégories uniquement depuis la DB (voulu !)
          ...DATA.LESSONS_CATEGORIES.entries.map((cat) => ProfileCategoryProgressionTile(cat.key, cat.value, this.userProfile)),
        ],
      ),
    );
  }
}

/// *********************************************
/// Une simple Tile pour afficher la progression d'une seule catégorie
/// *********************************************
class ProfileCategoryProgressionTile extends StatelessWidget {
  // Il faut les infos de la catégorie et l'utilisateur pour connaitre la progression
  final Map<String, dynamic> category;
  final String catId;
  final userProfile;

  ProfileCategoryProgressionTile(this.catId, this.category, this.userProfile);

  @override
  Widget build(BuildContext context) {
    // On récup les infos sur la catégorie
    // Le nombre total de leçons. Renvoie -1 Si la catégorie n'existe pas.
    final int nbTotalLessons = Provider.of<LessonsStructure>(context, listen: false).getNbLessons(this.catId);

    // On return un text ou rien, si la catégorie n'existe pas ou est vide
    if (nbTotalLessons < 0) return Container(child: Text('La catégorie $catId n\'existe pas dans la DB'));
    if (nbTotalLessons == 0) return Container();

    // La quantité de leçons terminées par l'utilisateur
    final int nbCompleteLessons = this.userProfile.getCompletedLessonsByCategory(this.catId);

    // On calcule la progression
    final double progressionPercentage = (nbTotalLessons == 0) ? 0 : nbCompleteLessons.toDouble() / nbTotalLessons.toDouble();

    return Column(
      children: [
        Row(
          children: [
            // L'icone
            Image.asset(this.category['icon'], height: 35),
            SizedBox(width: 5),
            // Le titre
            Expanded(
              child: AutoSizeText(
                this.category['title'].toString().tr(),
                style: TextStyle(fontSize: 22),
                maxLines: 1,
              ),
            ),

            SizedBox(width: 5),
            LessonsCategoryProgression(
              progressionPercentage: progressionPercentage,
              color: this.category['color'],
            )
          ],
        ),
        Divider(thickness: 2),
      ],
    );
  }
}
