import 'package:flutter/material.dart';

class DATA {
  /// *********************************************
  /// Les langues possibles dans l'application
  /// *********************************************
  static const Map<String, Map<String, dynamic>> LANGUAGES = {
    'fr': {'native_name': 'Français'},
    'en': {'native_name': 'English'},
  };
  /// Ne pas oublier d'ajouter le fichier json et l'image du drapeau

  /// *********************************************
  /// Ce qui s'affiche sur le swiper du début
  /// *********************************************
  static const List<Map<String, dynamic>> FEATURES = [
    {
      'image': 'assets/icons/240/etudiante.png',
      'title': 'features_swiper_title_learn',
      'description': 'features_swiper_description_learn',
    },
    {
      'image': 'assets/icons/240/couronne-de-laurier.png',
      'title': 'features_swiper_title_reward',
      'description': 'features_swiper_description_reward',
    },
    {
      'image': 'assets/icons/240/music-band.png',
      'title': 'features_swiper_title_social',
      'description': 'features_swiper_description_social',
    },
    {
      'image': 'assets/icons/240/podium.png',
      'title': 'features_swiper_title_challenge',
      'description': 'features_swiper_description_challenge',
      'scale': 1.0,
    }
  ];

  /// *********************************************
  /// Les catégories des leçons
  /// *********************************************
  static const Map<String, Map<String, dynamic>> LESSONS_CATEGORIES = {
    // Lecture
    'c1_notation': {
      'icon': 'assets/icons/240/lesson_c1_notation.png',
      'title': 'lesson_category_notation',
      'description': 'lesson_category_description_notation',
      'color': Colors.red
    },
    // Audition
    'c2_eartraining': {
      'id': 'c2_eartraining',
      'icon': 'assets/icons/240/lesson_c2_eartraining.png',
      'title': 'lesson_category_eartraining',
      'description': 'lesson_category_description_eartraining',
      'color': Colors.orange
    },
    // Histoire
    'c3_history': {
      'icon': 'assets/icons/240/lesson_c3_history.png',
      'title': 'lesson_category_history',
      'description': 'lesson_category_description_history',
      'color': Colors.purple
    },
    // Analyse
    'c4_analysis': {
      'icon': 'assets/icons/240/lesson_c4_analysis.png',
      'title': 'lesson_category_analysis',
      'description': 'lesson_category_description_analysis',
      'color': Colors.teal
    },
    // Organologie
    'c5_organology': {
      'icon': 'assets/icons/240/lesson_c5_organology.png',
      'title': 'lesson_category_organology',
      'description': 'lesson_category_description_organology',
      'color': Colors.brown,
    },
    // Harmonie
    'c6_harmony': {
      'icon': 'assets/icons/240/lesson_c6_harmony.png',
      'title': 'lesson_category_harmony',
      'description': 'lesson_category_description_harmony',
      'color': Colors.green
    },
  };

  // Le nombre de gemmes qu'on gagne en terminant une leçon de base.
  static const double COMPLETE_LESSON_REWARD = 10;
  // Le nombre de gemmes qu'on gagne en révisant une .
  static const double COMPLETE_LESSON_REVISION_REWARD = 4;
  // La multiplication en cas de visionnage de pub !
  static const double COMPLETE_LESSON_REWARDED_AD = 5;

  // Le multiplicateur de coût
  static const Map<int, double> COMPLETE_LESSON_COST_REWARD = {
    1: 1,
    2: 1.25,
    3: 1.5,
    4: 1.75,
    5: 2,
  };

  // Le multiplicateur de difficulté
  static const Map<int, double> COMPLETE_LESSON_DIFFICULTY_REWARD = {
    1: 1,
    2: 2,
    3: 3,
    4: 4,
    5: 5,
  };



  /// *********************************************
  /// Les catégories des défis
  /// *********************************************
  static const Map<String, Map<String, dynamic>> CHALLENGES_CATEGORIES = {
    'note_rush': {
      'icon': 'assets/icons/96/challenge-sprint.png',
      'title': 'challenges_category_note_rush',
      'path': '/note-rush-choice',
    }
  };

  static const List<Map<String, dynamic>> CHALLENGE_KEYSLIST = [
    {'name': 'Gkey', 'type': 'G', 'line': 2},
    {'name': 'Fkey', 'type': 'F', 'line': 4},
    {'name': 'Ckey3_small', 'type': 'C', 'line': 3},
    {'name': 'Ckey4_small', 'type': 'C', 'line': 4},
  ];

  static const List<Map<String, dynamic>> CHALLENGE_TIMELIST = [
    {'name': '3min', 'time': 180, 'icon': 'timer-vert.png'},
    {'name': '1min', 'time': 60, 'icon': 'timer-jaune.png'},
    {'name': '30s', 'time': 30, 'icon': 'timer-rouge.png'},
  ];

  /// *********************************************
  /// Les onglets dans le profil
  /// *********************************************
  static const List<Map<String, dynamic>> PROFILE_TABS = [
    //{'name': 'posts', 'icon': 'assets/icons/96/profil-grille.png'},
    //{'name': 'music', 'icon': 'assets/icons/96/profil-musique.png'},
    {'name': 'user_infos', 'icon': 'assets/icons/96/user-infos.png'},
    {'name': 'lessons', 'icon': 'assets/icons/96/profil-lessons.png'}

  ];
}
