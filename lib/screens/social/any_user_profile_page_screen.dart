
import 'package:FaBemol/widgets/profile/profile_page.dart';
import 'package:flutter/material.dart';

class AnyUserProfilePageScreen extends StatelessWidget {
  static const String routeName = '/any-user-profile-page';


  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    return Scaffold(
          body: SafeArea(
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                child: ProfilePage(args['userId']),
              ),
            ),
          ),
        );

  }
}
