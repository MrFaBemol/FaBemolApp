
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //MusicStaff staff = MusicStaff(key: );

    //Provider.of<UserProfile>(context, listen: false).isNewPB(challengeId: 'note_rush', score: 8, category: {'key': 'G2', 'time': '30s'});

    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/logotmp2.png',
            width: double.infinity,
          ),
          Divider(height: 1),
          SizedBox(height: 20),
          Text(
            'On va bien trouver quelque chose à afficher par ici ',
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
