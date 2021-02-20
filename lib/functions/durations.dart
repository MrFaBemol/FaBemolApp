extension CustomDoubleOperations on Duration {
  String toStringMS() {
    String nbSec = this.inSeconds > 9 ? this.inSeconds.toString() : '0' + this.inSeconds.toString();
    String nbMin = this.inMinutes > 9 ? this.inMinutes.toString() : '0' + this.inMinutes.toString();
    return nbMin + ':' + nbSec;
  }

  /// *********************************************
  /// Retourne un pourcentage d'avancement par rapport à comparedDuration
  /// *********************************************
  double percentOf(Duration comparedDuration) {
    //print(this.inMilliseconds);
    // Pour pas avoir de division par zéro
    if (comparedDuration == Duration.zero) return 0.0;
    // Calcul et impossible de dépasser 1 !
    double percent = (this.inMicroseconds / 1000000).toDouble() / (comparedDuration.inMicroseconds / 1000000).toDouble();
    return percent > 1 ? 1.0 : percent;
  }
}
