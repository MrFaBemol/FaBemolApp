
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {




  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        children: [
          Text(
            'Page d\'accueil !',
            style: TextStyle(fontSize: 42),
          ),


        ],
      ),
    );
  }
}
