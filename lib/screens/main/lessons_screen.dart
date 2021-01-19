import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/widgets/lessons/lesson_category_card_item.dart';
import 'package:flutter/material.dart';

class LessonsScreen extends StatelessWidget {
  static const String routeName = '/lessons';

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        children: [
          // On parcourt les catégories stockées dans le fichier DATA
          // Il est donc impossible d'ajouter des catégories uniquement depuis la DB (voulu !)
          ...DATA.LESSONS_CATEGORIES.entries.map((cat) => LessonCategoryCard(cat.key, cat.value)),
        ],
      ),
    );
  }
}
