import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:FaBemol/functions/localization.dart';


class ProfileTabChallenge extends StatelessWidget {
  final userProfile;

  ProfileTabChallenge(this.userProfile);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Le titre de l'onglet
          AutoSizeText(
            'challenge_PB'.tr(),
            style: Theme.of(context).textTheme.headline6,
            maxLines: 1,
          ),
          SizedBox(height: 10),

        ],
      ),
    );
  }
}
