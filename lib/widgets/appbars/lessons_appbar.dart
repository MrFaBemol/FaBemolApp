import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/providers/user_profile.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:FaBemol/functions/numbers.dart';
import 'package:FaBemol/widgets/appbars/widgets/lessons_counter_widget.dart';
import 'package:FaBemol/widgets/appbars/widgets/lives_counter_widget.dart';
import 'package:flutter/material.dart';

import 'package:FaBemol/functions/localization.dart';
import 'package:provider/provider.dart';

class LessonsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String catId;

  const LessonsAppBar({
    Key key,
    this.height = 45,
    this.catId = 'none',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = catId != 'none'
        ? DATA.LESSONS_CATEGORIES[catId]['color']
        : Theme.of(context).shadowColor;
    //final color = Theme.of(context).shadowColor;

    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              // La bordure qui doit etre basique si on a pas de catégorie
              border: catId == 'none'
                  ? Border(bottom: BorderSide(width: 1.0, color: color))
                  : Border(),
            ),
            padding: EdgeInsets.only(left: 5, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Le nom de la catégorie s'il existe
                if (catId != 'none') Expanded(child: CategoryName(catId)),

                // Sinon, le drawer et un espace blanc
                if (catId == 'none') DrawerIcon(),
                if (catId == 'none') Expanded(child: SizedBox()),

                // Les lauriers
                LessonsCounterWidget(),

                SizedBox(width: 10),

                // Les coeurs
                LivesCounterWidget(),
              ],
            ),
          ),
        ),

        // SI on a une catégorie, on affiche une "bordure" avec un gradient
        /*
        if (catId != 'none')
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.shade800,
                  color.shade200,
                  color.shade800,
                ],
              ),
            ),
          ),

         */
      ],
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

/// *********************************************
/// S'affiche si on est dans une catégorie
/// *********************************************
class CategoryName extends StatelessWidget {
  final String catId;

  CategoryName(this.catId);

  @override
  Widget build(BuildContext context) {
    final category = DATA.LESSONS_CATEGORIES[catId];

    return Row(
      children: [
        InkWell(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        SizedBox(
          width: 5
        ),
        Hero(
            tag: this.catId + '_icon_hero',
            child: Image.asset(category['icon']),),
        SizedBox(
          width: 5
        ),
        Expanded(
          child: Hero(
            tag: this.catId + '_title_hero',
            child: AutoSizeText(
              category['title'].toString().tr(),
              style: Theme.of(context).textTheme.headline6,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class DrawerIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    UserProfile userProfile = Provider.of<UserProfile>(context);

    return InkWell(
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          Image.asset('assets/icons/96/topaze.png', height: 28,),
          AutoSizeText(
            userProfile.currencyBalance.toStringFormatted(),
            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 24),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
