import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Future<dynamic> showRoundedMBS({BuildContext context, Widget child}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: child,
      );
    },
    // Pour que ce soit arrondi et joli
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
    ),
  );
}
