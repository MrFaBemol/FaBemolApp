// Import principaux
import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/widgets/appbars/challenge_appbar.dart';
import 'package:FaBemol/widgets/drawers/lessons_drawer.dart';
import 'package:FaBemol/widgets/drawers/profile_drawer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:FaBemol/functions/localization.dart';

// Import des screens principaux
import 'package:FaBemol/screens/main/challenge_screen.dart';
import 'package:FaBemol/screens/main/home_screen.dart';
import 'package:FaBemol/screens/main/lessons_screen.dart';
import 'package:FaBemol/screens/main/social_screen.dart';
import 'package:FaBemol/screens/main/profile_screen.dart';

// Import des widgets
import 'package:FaBemol/widgets/appbars/lessons_appbar.dart';
import 'package:FaBemol/widgets/appbars/profile_appbar.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  static const String routeName = 'homepage';

  final int index;

  TabsScreen({this.index = 2});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  // Liste des pages de l'interface principale :
  List<Map<String, dynamic>> _pages = [
    {
      //'icon': Icon(Icons.school),
      'assetIcon' : 'assets/icons/96/profil-lessons.png',
      'title': 'tab_lessons'.tr(),
      'appbar': LessonsAppBar(),
      'drawer': LessonsDrawer(),
      'screen': LessonsScreen(),
    },
    {
      //'icon': Icon(Icons.emoji_events),
      'assetIcon' : 'assets/icons/96/trophee.png',
      'title': 'tab_challenge'.tr(),
      'appbar': ChallengeAppBar(),
      'screen': ChallengeScreen()
    },

    {
      //'icon': Icon(Icons.home),
      'assetIcon' : 'assets/icons/96/accueil.png',
      'title': 'tab_home'.tr(),
      'screen': HomeScreen(),
    },
    {
      //'icon': Icon(Icons.group),
      'assetIcon' : 'assets/icons/96/social_group.png',
      'title': 'tab_social'.tr(),
      'screen': MeetScreen(),
    },
    {
      //'icon': Icon(Icons.account_circle),
      'profilePicture': true,
      'assetIcon' : 'assets/icons/96/profile-picture.png',
      'title': 'tab_profile'.tr(),
      'appbar': ProfileAppBar(),
      'endDrawer': ProfileDrawer(),
      'screen': ProfileScreen()
    },
  ];

  int _selectedIndex; // La variable qui gère la page affichée

  @override
  void initState() {
    this._selectedIndex = widget
        .index; // On récupère l'index passé en argument (ou celui par défaut).
    super.initState();
  }

  // La fonction qui change les tabs, tout simplement !
  void _selectTab(int index) {
    Provider.of<UserProfile>(context, listen: false).setTabIndex(index);
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    /*print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);*/

    return Scaffold(
      body: SafeArea(
        child:  Container(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: _pages[_selectedIndex]['screen'],
            ),
          ),

      ),

      // Si une appBar est défini
      appBar: _pages[_selectedIndex]['appbar'] != null
          ? _pages[_selectedIndex]['appbar']
          : null,
      drawer: _pages[_selectedIndex]['drawer'] != null
          ? _pages[_selectedIndex]['drawer']
          : null,
      endDrawer: _pages[_selectedIndex]['endDrawer'] != null
          ? _pages[_selectedIndex]['endDrawer']
          : null,

      bottomNavigationBar: FlashyTabBar(
        animationDuration: Duration(milliseconds: 500),
        animationCurve: Curves.ease,
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: _selectTab,
        iconSize: 26,
        items: [
          ..._pages.map(
            (e) {
              return FlashyTabBarItem(
                //icon: e['icon'],
                assetIcon: e['assetIcon'] != null ? e['assetIcon'] : null,
                profilePicture: e['profilePicture'] != null && Provider.of<UserProfile>(context, listen: false).hasProfilePicture ? Provider.of<UserProfile>(context, listen: false).profilePicture : null ,
                title: Text(e['title'], style: TextStyle(fontSize: 14), maxLines: 1,),
              );
            },
          )
        ],
      ),
    );
  }
}
