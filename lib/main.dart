import 'package:FaBemol/providers/ad_manager.dart';
import 'package:FaBemol/providers/any_user_profile.dart';
import 'package:FaBemol/providers/lesson.dart';
import 'package:FaBemol/providers/rankings.dart';
import 'package:FaBemol/providers/searchs.dart';
import 'package:FaBemol/screens/challenge/note_rush_choice_screen.dart';
import 'package:FaBemol/screens/challenge/note_rush_game_screen.dart';
import 'package:FaBemol/screens/lessons/lesson_complete_screen.dart';
import 'package:FaBemol/screens/lessons/lesson_overview_screen.dart';
import 'package:FaBemol/screens/lessons/lesson_steps_screen.dart';
import 'package:FaBemol/screens/load_and_redirect_screen.dart';
import 'package:FaBemol/screens/social/any_user_profile_page_screen.dart';
import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/themes/themes_list.dart';

// Flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

//Firebase
import 'package:firebase_core/firebase_core.dart';

//Screens
import 'package:FaBemol/screens/auth_screen.dart';
import 'package:FaBemol/screens/tabs_screen.dart';
import 'package:FaBemol/screens/lessons/lessons_list_screen.dart';

// Providers
import 'package:FaBemol/providers/lessons_structure.dart';
import 'package:FaBemol/providers/user_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //print(DATA.LANGUAGES.keys.toList());
  //print('lol : ' + LocalizationDefaultType.device.toString());

  await translator.init(
    localeDefault: LocalizationDefaultType.device,
    languagesList: DATA.LANGUAGES.keys.toList(),
    assetsDirectory: 'assets/translations/',
  );

  // On init flutter ici
  await Firebase.initializeApp();
  runApp(
    LocalizedApp(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => LessonsStructure()),
        ChangeNotifierProvider(create: (ctx) => UserProfile()),
        ChangeNotifierProvider(create: (ctx) => AnyUserProfile()),
        ChangeNotifierProvider(create: (ctx) => Lesson()),
        ChangeNotifierProvider(create: (ctx) => Searchs()),
        ChangeNotifierProvider(create: (ctx) => AdManager()),
        ChangeNotifierProvider(create: (ctx) => Rankings()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: true,
        title: 'Fa Bémol',

        localizationsDelegates: translator.delegates,
        locale: translator.locale,
        supportedLocales: translator.locals(),

        home: LoadAndRedirectScreen(),

        routes: {
          TabsScreen.routeName: (_) => TabsScreen(),
          AuthScreen.routeName: (_) => AuthScreen(),

          // Leçons
          LessonsListScreen.routeName: (_) => LessonsListScreen(),
          LessonOverviewScreen.routeName: (_) => LessonOverviewScreen(),
          LessonStepsScreen.routeName: (_) => LessonStepsScreen(),
          LessonCompleteScreen.routeName: (_) => LessonCompleteScreen(),

          //Challenges
          NoteRushChoiceScreen.routeName: (_) => NoteRushChoiceScreen(),
          NoteRushGameScreen.routeName: (_) => NoteRushGameScreen(),

          // Social
          AnyUserProfilePageScreen.routeName: (_) => AnyUserProfilePageScreen(),
        },

        //*****************************************************
        //*****************************************************
        //              THEME INFORMATIONS
        //*****************************************************
        //*****************************************************

        theme: themes['blueOrange'],
      ),
    );
  }
}
