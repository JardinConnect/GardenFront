class Utils {

  static String getLastUpdateText(DateTime lastUpdateAt) {
    final result = StringBuffer();
    result.write("Mis à jour il y a");

    Duration difference = DateTime.now().difference(lastUpdateAt);

    if (difference.inSeconds < 60) {
      result.write(
        " ${difference.inSeconds} ${difference.inSeconds == 1 ? 'seconde' : 'secondes'}",
      );
    } else if (difference.inMinutes < 60) {
      result.write(
        " ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}",
      );
    } else if (difference.inHours < 24) {
      result.write(
        " ${difference.inHours} ${difference.inHours == 1 ? 'heure' : 'heures'}",
      );
    } else {
      result.write(
        " ${difference.inDays} ${difference.inDays == 1 ? 'jour' : 'jours'}",
      );
    }

    return result.toString();
  }
}