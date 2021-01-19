import 'package:flutter/material.dart';

class ProfileTabUserInfos extends StatelessWidget {
  final userProfile;

  ProfileTabUserInfos(this.userProfile);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Les infos de l\'utilisateur'),
    );
  }
}
