import 'package:intl/intl.dart';

extension CamelCaseStringExtension on String {
  String toCamelCase() {
    try {
      List<String> words = split(RegExp(r'\s+|_+'));

      String camelCaseString = words.map((word) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');

      return camelCaseString;
    } catch (e) {
      return this;
    }
  }
}

fahrenheitToCelsius(kelvin) {
  return (kelvin - 273.15).toStringAsFixed(0);
}

String getTimeFromUnixTimestamp(int timestamp, {isDay}) {
  if (isDay) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    return DateFormat.E().format(dateTime);
  }
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  // Convert to local time if needed
  dateTime = dateTime.toLocal();
  // Format the DateTime to 12-hour format with AM/PM
  String formattedTime = DateFormat.jm().format(dateTime);
  return formattedTime;
}
