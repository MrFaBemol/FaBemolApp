import 'dart:ui';
import 'package:flutter/material.dart';


class BlurryDialog extends StatelessWidget {

  final String title;
  final String content;
  final VoidCallback continueCallBack;
  final String buttonOk;
  final String buttonCancel;


  BlurryDialog({this.title, this.content, this.continueCallBack, this.buttonOk = 'none', this.buttonCancel});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child:  AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text(buttonCancel, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            if (this.buttonOk != 'none')
              FlatButton(
                child: new Text(buttonOk, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),),
                onPressed: () {
                  continueCallBack();
                },
              ),
          ],
        ));
  }
}