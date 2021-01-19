extension CustomDoubleOperations on double {
  String toStringFormatted() {
    List<String> abbreviations = ['', 'K', 'M'];
    double doubleAbbr = this;
    int textAbbr = 0;
    // On boucle pour tous les milliers
    for (double i = this; i > 1000; i /= 1000) {
      doubleAbbr = doubleAbbr / 1000;
      textAbbr++;
    }
    return textAbbr > 0 ? doubleAbbr.toStringAsFixed(1) + abbreviations[textAbbr] : doubleAbbr.toStringAsFixed(0);
  }

  String toStringTimeFormatted({bool clockFormat = false, bool showHours = true}) {
    double hours = this / 3600;
    double minutes = hours * 60;
    double seconds = (minutes - minutes.truncateToDouble()) * 60;
    // Le fix pour les minutes que j'avais oublié
    minutes = (hours - hours.truncateToDouble()) * 60;


    // On formatte tout et on rajoute des zéros si besoin pour avoir toujours 2 chiffres
    String hrsStr = hours.round().toString();
    String minStr = minutes.truncate().toString();
    String secStr = seconds.round().toString();
    secStr = (seconds < 10) ? '0'+secStr : secStr;
    minStr = (minutes < 10) ? '0'+minStr : minStr;
    hrsStr = (hours < 10) ? '0'+hrsStr : hrsStr;

    String formattedTime;

    if (clockFormat){
      formattedTime = (showHours) ? hrsStr + ':' + minStr + ':' + secStr : minStr + ':' + secStr;
    } else{
      formattedTime = (showHours) ? hrsStr + 'h ' + minStr + 'm ' + secStr +'s' : minStr + 'm ' + secStr +'s';
    }
    return formattedTime;
  }
}

extension CustomIntOperations on int {
  String toStringFormatted() {
    return this.toDouble().toStringFormatted();
  }

  String toStringTimeFormatted({bool clockFormat = false, bool showHours = true}) {
    return this.toDouble().toStringTimeFormatted(clockFormat: clockFormat, showHours: showHours);
  }
}
