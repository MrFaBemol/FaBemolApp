import 'package:FaBemol/providers/user_profile.dart';
import 'package:FaBemol/widgets/blurry_dialog.dart';
import 'package:FaBemol/widgets/language_picker.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Text(
              'Drawer du profil',
              style: Theme.of(context).textTheme.headline6,
            ),
            Divider(
              thickness: 1,
            ),
            // Le picker de langue
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'language'.tr() + ' : ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(width: 10),
                LanguagePicker(mustConfirm: true,),
              ],
            ),

            Expanded(
              child: SizedBox(),
            ),


            //@todo: styler un peu les boutons (alignement par ex)

            InkWell(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlurryDialog(
                        title: 'warning'.tr(),
                        content: 'ask_reset_progression'.tr(),
                        buttonOk: 'yes'.tr(),
                        buttonCancel: 'no'.tr(),
                        continueCallBack: () {
                          Provider.of<UserProfile>(context, listen: false).resetProgression();
                          Navigator.of(context).pop();
                        },
                      );
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.autorenew),
                  SizedBox(
                    width: 10,
                  ),
                  AutoSizeText(
                    'reset_progression'.tr(),
                    style: TextStyle(fontSize: 16),
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            SizedBox(height: 10,),

            InkWell(
              onTap: () {
                // On affiche la boite de confirmation
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BlurryDialog(
                        title: 'warning'.tr(),
                        content: 'ask_logout'.tr(),
                        buttonOk: 'yes'.tr(),
                        buttonCancel: 'no'.tr(),
                        continueCallBack: () {
                          // On clear la session du provider et on se déconnecte
                          Provider.of<UserProfile>(context, listen: false).logoutUser();
                          Navigator.of(context).pop();
                        },
                      );
                    });


              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 10,
                  ),
                  AutoSizeText(
                    'logout'.tr(),
                    style: TextStyle(fontSize: 16),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
