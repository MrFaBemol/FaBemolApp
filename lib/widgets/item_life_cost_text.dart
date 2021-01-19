import 'package:flutter/material.dart';
import 'package:FaBemol/functions/localization.dart';

class LifeCostText extends StatelessWidget {
  final int cost;

  LifeCostText(this.cost);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'cost'.tr() + ' : $cost',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(width: 5),
        Image.asset(
          'assets/icons/96/music-heart.png',
          height: 22,
        ),
      ],
    );
  }
}
