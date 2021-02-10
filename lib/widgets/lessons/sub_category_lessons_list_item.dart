import 'package:FaBemol/providers/lessons_structure.dart';
import 'package:FaBemol/widgets/lessons/chapter_lessons_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubCategoryLessonsList extends StatelessWidget {
  final String catId;
  final String subCatId;

  SubCategoryLessonsList(this.catId, this.subCatId);

  @override
  Widget build(BuildContext context) {
    List<String> chaptersOrder = Provider.of<LessonsStructure>(context, listen: false).getChaptersOrder(this.catId, this.subCatId);

    /*
    ...chaptersOrder.map((chapterId) {
            return ChapterLessonsList(this.catId, this.subCatId, chapterId);
          }),
     */

    // La singleChildScrollView est importante pour scroll verticalement
    return SingleChildScrollView(
      child: Column(
        // On positionne tout a partir d'en haut à gauche
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...chaptersOrder.map((chapterId) {
            return ChapterLessonsList(this.catId, this.subCatId, chapterId);
          }),
        ],
      ),
    );
  }
}
