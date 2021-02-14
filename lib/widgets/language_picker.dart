import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/widgets/blurry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:FaBemol/functions/localization.dart';

class LanguagePicker extends StatelessWidget {
  final bool mustConfirm;

  LanguagePicker({this.mustConfirm = false});

  @override
  Widget build(BuildContext context) {

    return DropdownButton<String>(
      value: DATA.LANGUAGES.containsKey(translator.currentLanguage) ? translator.currentLanguage : DATA.DEFAULT_LANGUAGE,
      items: translator.langsList.map((value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              Image.asset('assets/icons/flags/' + value + '.png', height: 20),
              SizedBox(width: 5),
              Text(DATA.LANGUAGES[value]['native_name']),
            ],
          ),
        );
      }).toList(),
      onChanged: (newLanguage) {
        // Si le language choisi est différent de celui utilisé
        if (newLanguage != translator.currentLanguage) {
          // On envoie le Dialog de confirmation
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlurryDialog(
                  title: 'warning'.tr(),
                  content: 'ask_change_language'.tr(),
                  buttonOk: 'yes'.tr(),
                  buttonCancel: 'no'.tr(),
                  continueCallBack: () {
                    translator.setNewLanguage(context, newLanguage: newLanguage, restart: true, remember: true);
                    Navigator.of(context).pop();
                  },
                );
              });
        }
      },
    );
  }
}
