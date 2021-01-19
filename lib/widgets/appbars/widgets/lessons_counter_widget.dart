import 'package:FaBemol/providers/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LessonsCounterWidget extends StatefulWidget {
  @override
  _LessonsCounterWidgetState createState() => _LessonsCounterWidgetState();
}

class _LessonsCounterWidgetState extends State<LessonsCounterWidget> {
  @override
  Widget build(BuildContext context) {

    return Row(children: [
      Image.asset(
        'assets/icons/96/couronne-de-laurier.png',
        height: 28,
      ),
      SizedBox(
        width: 4,
      ),
      Text(
        Provider.of<UserProfile>(context).getCompletedLessons().toString(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    ]);

  }
}
