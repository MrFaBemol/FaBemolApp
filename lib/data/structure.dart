
// *************** FICHIER INUTILE, UNIQUEMENT POUR AVOIR LES IDEES CLAIRES EN CAS DE BESOIN
// ET POUR CHANGER LA BASE DE DONNÉES ÉVENTUELLEMENT

// Catégorie 1 : Notation
Map<String, dynamic> notationStructure = {
  'notation_subcategory_notes': {
    'basics': [],
    'Gkey2': [],
    'Fkey4': [],
    'Ckey3': [],
    'Ckey4': [],
  },
  'notation_subcategory_rhythms': {
    'basics': [],
    'binary': [],
    'ternary': [],
  },
  'notation_subcategory_staff': {
    'structure': [],
    'staffhead': [],
    'others': [],
  },
  'notation_subcategory_signs': {
    'dynamics': [],
    'articulations': [],
  },
};

// Ordre des subCat
List<String> notationSubCategoriesOrder = [
  'notation_subcategory_notes',
  'notation_subcategory_rhythms',
  'notation_subcategory_staff',
  'notation_subcategory_signs',
];
// Ordre des chapitres
Map<String, List<String>> notationChaptersOrder = {
  'notation_subcategory_notes' : ['basics', 'Gkey2', 'Fkey4', 'Ckey3', 'Ckey4'],
  'notation_subcategory_rhythms' : ['basics', 'binary', 'ternary'],
  'notation_subcategory_staff' : ['structure', 'staffhead', 'others'],
  'notation_subcategory_signs' : ['dynamics', 'articulations'],
};

//***************************
// Catégorie 2 : EAR TRAINING
Map<String, dynamic> eartrainingStructure = {
  'eartraining_subcategory_intervals': {
    'basics': [],
    'small_intervals': [],
    'big_intervals': [],
    'giant_intervals': [],
  },
  'eartraining_subcategory_chords': {
    'basics': [],
    '3chords': [],
    '4chords': [],
    'complexchords': [],
  },
  'eartraining_subcategory_dictations': {
    'dictations_intervals': [],
    'dictations_rhythms': [],
    'dictations_chords': [],
  },
};
// Ordre des subCat
List<String> eartrainingSubCategoriesOrder = [
  'eartraining_subcategory_intervals',
  'eartraining_subcategory_chords',
  'eartraining_subcategory_dictations',
];
// Ordre des chapitres
Map<String, List<String>> eartrainingChaptersOrder = {
  'eartraining_subcategory_intervals' : ['basics', 'small_intervals', 'big_intervals', 'giant_intervals'],
  'eartraining_subcategory_chords' : ['basics', '3chords', '4chords', 'complexchords'],
  'eartraining_subcategory_dictations' : ['dictations_intervals', 'dictations_rhythms', 'dictations_chords'],
};


//***************************
// Catégorie 3 : Histoire
Map<String, dynamic> historyStructure = {
  'history_subcategory_periods': {
    'music_origins': [],
    'middle_ages': [],
    'renaissance': [],
    'baroque_period': [],
    'classical_period': [],
    'romantic_period': [],
    'XXe_century': [],
    'music_today': [],
  },
  'history_subcategory_composers': { 'A': [],'B': [],'C': [],'D': [],'E': [],'F': [],'G': [],'H': [],'I': [],'J': [],'K': [],'L': [],'M': [],'N': [],'O': [], 'P': [],'Q': [], 'R': [], 'S': [], 'T': [], 'U': [], 'V': [], 'W': [], 'X': [], 'Y': [], 'Z': []},
  'history_subcategory_performers': {'A': [],'B': [],'C': [],'D': [],'E': [],'F': [],'G': [],'H': [],'I': [],'J': [],'K': [],'L': [],'M': [],'N': [],'O': [], 'P': [],'Q': [], 'R': [], 'S': [], 'T': [], 'U': [], 'V': [], 'W': [], 'X': [], 'Y': [], 'Z': []},
};
// Ordre des subCat
List<String> historySubCategoriesOrder = [
  'history_subcategory_periods',
  'history_subcategory_composers',
  'history_subcategory_performers',
];
// Ordre des chapitres
Map<String, List<String>> historyChaptersOrder = {
  'history_subcategory_periods' : ['music_origins', 'middle_ages', 'renaissance', 'baroque_period', 'classical_period', 'romantic_period', 'XXe_century', 'music_today' ],
  'history_subcategory_composers' : ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
  'history_subcategory_performers' : ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
};


//***************************
// Catégorie 4 : Analyse
Map<String, dynamic> analysisStructure = {
  'analysis_subcategory_forms': {
    'basics': [],
    'ancient_forms': [],
    'baroque_forms': [],
    'classical_forms': [],
    'romantic_forms': [],
    'modern_forms': [],
  },
  'analysis_subcategory_ensembles': {
    'soloist': [],
    'chamber_music': [],
    'medium_ensemble': [],
    'symphonic_orchestra': [],
  },
};
// Ordre des subCat
List<String> analysisSubCategoriesOrder = [
  'analysis_subcategory_forms',
  'analysis_subcategory_ensembles',
];
// Ordre des chapitres
Map<String, List<String>> analysisChaptersOrder = {
  'analysis_subcategory_forms' : ['basics', 'ancient_forms', 'baroque_forms', 'classical_forms', 'romantic_forms', 'modern_forms' ],
  'analysis_subcategory_ensembles' : ['soloist', 'chamber_music', 'medium_ensemble', 'symphonic_orchestra',],
};


//***************************
// Catégorie 5 : Instruments
Map<String, dynamic> organologyStructure = {
  'organology_subcategory_families': {
    'keyboards': [],
    'strings': [],
    'woodwinds': [],
    'brass': [],
    'percussions': [],
    'voices': [],
  },
  'organology_subcategory_ancient': {
    'antiquity': [],
    'renaissance_baroque': [],
  },
  'organology_subcategory_rare': {
    'unusual_instruments': [],
    'natural_instruments': [],
  },
};
// Ordre des subCat
List<String> organologySubCategoriesOrder = [
  'organology_subcategory_families',
  'organology_subcategory_ancient',
  'organology_subcategory_rare',
];
// Ordre des chapitres
Map<String, List<String>> organologyChaptersOrder = {
  'organology_subcategory_families' : ['keyboards', 'strings', 'woodwinds', 'brass', 'percussions', 'voices' ],
  'organology_subcategory_ancient' : ['antiquity', 'renaissance_baroque',],
  'organology_subcategory_rare' : ['unusual_instruments', 'natural_instruments',],
};

//***************************
// Catégorie 6 : Harmonie
Map<String, dynamic> harmonyStructure = {
  'harmony_subcategory_harmony': {
    'basics': [],
    '3chords': [],
    '4chords_more': [],
    'nonharmonic_tones': [],
    'study_styles': [],
  },
  'harmony_subcategory_counterpoint': {
    'basics': [],
  },
  'harmony_subcategory_fugue': {
    'basics': [],
  },
  'harmony_subcategory_composition': {
    'basics': [],
  },
};
// Ordre des subCat
List<String> harmonySubCategoriesOrder = [
  'harmony_subcategory_harmony',
  'harmony_subcategory_counterpoint',
  'harmony_subcategory_fugue',
  'harmony_subcategory_composition',
];
// Ordre des chapitres
Map<String, List<String>> harmonyChaptersOrder = {
  'harmony_subcategory_harmony' : ['basics', '3chords', '4chords_more', 'nonharmonic_tones', 'study_styles', ],
  'harmony_subcategory_counterpoint' : ['basics',],
  'harmony_subcategory_fugue' : ['basics',],
  'harmony_subcategory_composition' : ['basics', ],
};