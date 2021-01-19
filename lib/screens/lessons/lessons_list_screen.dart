import 'package:FaBemol/providers/lessons_structure.dart';
import 'package:FaBemol/widgets/appbars/lessons_appbar.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:FaBemol/widgets/lessons/sub_category_lessons_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:FaBemol/functions/localization.dart';

class LessonsListScreen extends StatefulWidget {
  static const String routeName = 'lessons-list';

  @override
  _LessonsListScreenState createState() => _LessonsListScreenState();
}

class _LessonsListScreenState extends State<LessonsListScreen> {
  @override
  Widget build(BuildContext context) {
    // Les infos
    final catId = ModalRoute.of(context).settings.arguments as String;

    // Les catégories qui se font fetch pépouze, on crée les Tabs dans le bon ordre
    final lessonsStructure = Provider.of<LessonsStructure>(context);

    // On récup l'ordre des sous catégories de la catégorie en question
    final List<String> subCategoriesOrder =
        lessonsStructure.getSubCategoriesOrder(catId);

    // On crée les onglets à partir des key dans l'ordre, qui sont alors traduites
    final List<Widget> subCategoriesTabs = subCategoriesOrder
        .map((subCatId) => Tab(
              text: subCatId.tr(),
            ))
        .toList();

    // Et ici on crée la liste qui sera affichée
    final List<Widget> subCategoriesLessonsList =
        subCategoriesOrder.map((subCatId) {
      return SubCategoryLessonsList(catId, subCatId);
    }).toList();


    //final color = DATA.LESSONS_CATEGORIES[catId]['color'];


    // **************  On envoie la page
    return Scaffold(
      appBar: LessonsAppBar(
        catId: catId,
      ),
      body: DefaultTabController(
        length: subCategoriesTabs.length,
        child: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [

              // Les onglets
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,

                // Le container Flat Design un peu spécial avec les bords arrondis seulement en bas
                child: ContainerFlatDesign(

                  padding: EdgeInsets.symmetric(horizontal: 5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  borderWidth: 0.5,

                  child: TabBar(
                    isScrollable: true,
                    tabs: subCategoriesTabs,
                    labelColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    indicator: DotIndicator(
                      color: Theme.of(context).primaryColor,
                      distanceFromCenter: 16,
                      radius: 3,
                      paintingStyle: PaintingStyle.fill,
                    ),
                  ),
                ),
              ),
              /*
              Container(
                height: 1,
                color: Theme.of(context).shadowColor.withOpacity(0.8),
              ),

               */

              // Les pages des chapitres, qui scrollent tranquillement
              Expanded(child: TabBarView(children: subCategoriesLessonsList)),
            ],
          ),
        )),
      ),
    );
  }
}
