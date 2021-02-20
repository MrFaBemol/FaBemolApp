import 'package:flutter/material.dart';


Color primaryColor = Color(0xFF14213d);
Color accentColor = Color(0xFFff9100);


//Color primaryColor = Color(0xFF1d3557);
// Color accentColor = Color(0xFFe63946);
Color nonWhiteBackground = Colors.grey[50];
// Color primaryColor = Color(0xFF253d5b);
//Color accentColor = Color(0xFFe06900);


ThemeData blueOrangeTheme = ThemeData(
  fontFamily: 'Raleway',

  brightness: Brightness.light,

  //scaffoldBackgroundColor:  Color(0xFFfff9f9),
  //backgroundColor: Color(0xFFfff9f9),
  scaffoldBackgroundColor: nonWhiteBackground,
  backgroundColor: Colors.white,
  bottomSheetTheme: BottomSheetThemeData(backgroundColor: nonWhiteBackground),

  primaryColor: primaryColor,
  accentColor: accentColor,
  // Color(0xFFe06900)

  shadowColor: Colors.blueGrey[200],
  errorColor: Colors.red,

  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.red),
    bodyText2: TextStyle(color: primaryColor, fontSize: 18),

// Titres
    headline4: TextStyle(
      fontFamily: 'Raleway',
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: primaryColor,      //color: Color(0xFF020d39),
    ),
    headline5: TextStyle(
      fontFamily: 'Raleway',
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
// TITRE DES CATEGORIES
    headline6: TextStyle(
        fontFamily: 'Raleway',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: primaryColor
    ),
  ),
//.apply(bodyColor: , displayColor: ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      primary: accentColor,
      // Color(0xFFe06900)
      onPrimary: Colors.white,
      onSurface: Colors.grey,
      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: StadiumBorder(),
      primary: accentColor,
      // Color(0xFFe06900)
      side: BorderSide(color: accentColor,),
      onSurface: Colors.white,
      backgroundColor: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: accentColor, // Color(0xFFe06900)
      ),
    ),
  ),


);