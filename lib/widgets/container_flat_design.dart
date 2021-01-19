import 'package:flutter/material.dart';

class ContainerFlatDesign extends StatelessWidget {

  final Color borderColor;
  final BorderRadiusGeometry borderRadius;
  final double borderWidth;

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final bool screenWidth;

  final Widget child;

  ContainerFlatDesign({
    this.borderColor,
    this.borderRadius,
    this.borderWidth = 1,

    this.margin,
    this.padding,
    this.screenWidth = false,

    @required this.child
  });

  @override
  Widget build(BuildContext context) {

    return Container(
        margin: this.margin != null ? this.margin : EdgeInsets.all(0),
        padding: this.padding != null ? this.padding : EdgeInsets.all(0),
        width: (this.screenWidth) ? MediaQuery.of(context).size.width : double.infinity,

        // On donne le flat design
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: this.borderRadius != null ? this.borderRadius : BorderRadius.circular(5),
          border: Border.all(
            color: Theme.of(context).shadowColor,
            width: this.borderWidth,
          ),

          boxShadow: [
            BoxShadow(
              // Effet 3D
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 2,
              offset: Offset(0, 1),
            )
          ],
        ),

        child: this.child,
    );
  }
}
