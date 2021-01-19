
import 'package:localize_and_translate/localize_and_translate.dart';

extension CustomLocalization on String {
  String tr() {
    return translator.translate(this);
    //return this;
  }
}

