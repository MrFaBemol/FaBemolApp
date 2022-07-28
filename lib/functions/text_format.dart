import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_rich_text/super_rich_text.dart';

extension CustomFormat on String {
  String addSmiley() {
    String result = this;
    SMILEYS.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
    //return this;
  }
}


const Map<String, String> SMILEYS = {
  // Emotes avec des signes
  ':)': '🙂',
  '(:': '🙃',
  ':D': '😃',
  ';)': '😉',
  ':\'(': '😢',    // Pleurs
  '\':)': '😅',    // Sueur souriant

  // Smileys avec des mots
  ':think:': '🤔️',
  ':suspect:': '🤔️',

  // Emotes avec des mots
  ':golf:': '⛳',
  ':ski:': '⛷️',
  ':sheep:': '🐑',
  ':trefle:': '🍀',

};


// Les marqueurs qui vont s'appliquer au SuperRichText si on lui passe la liste
List<MarkerText> markersList = [

  //*** Mettre en couleur
  MarkerText(
    marker: 'cBlue',
    style: TextStyle(color: Colors.blue),
  ),
  MarkerText(
    marker: 'cRed',
    style: TextStyle(color: Colors.red),
  ),
  MarkerText(
    marker: 'cGreen',
    style: TextStyle(color: Colors.green),
  ),


  //*** Mettre en couleur et en gras
  MarkerText(
    marker: '*cBlue',
    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  ),
  MarkerText(
    marker: '*cRed',
    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
  ),
  MarkerText(
    marker: '*cGreen',
    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
  ),

  MarkerText(
    marker: '*h1',
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  ),

];