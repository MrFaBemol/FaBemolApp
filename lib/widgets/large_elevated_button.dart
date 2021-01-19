import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LargeElevatedButton extends StatelessWidget {
  final String text;
  final double height;
  final Function onPressed;

  final double fontSize;

  LargeElevatedButton(
      {this.text, this.height, this.onPressed, this.fontSize = 24});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(1.5),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).shadowColor.withOpacity(0.3),
          boxShadow: [
            BoxShadow(
              // Effet 3D
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(10),
          ),

          height: this.height,
          alignment: Alignment.center,
          child: AutoSizeText(
            this.text,
            maxLines: 1,
            style: TextStyle(
                color: Colors.white,
                fontSize: this.fontSize,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      onTap: this.onPressed,
    );
  }
}
