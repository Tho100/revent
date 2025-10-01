import 'package:intl/intl.dart';
import 'package:revent/helper/extract_data.dart';

class FormatDate {

  final _dateNow = DateTime.now();

  String formatPostTimestamp(DateTime createdAt) {

    final difference = _dateNow.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
      
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';

    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';

    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';

    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo';

    } else {
      return '${(difference.inDays / 365).floor()}y';

    }

  }

  static int parseFormattedTimestamp(String timestamp) {

    if (timestamp.endsWith('m')) {
      return int.parse(timestamp.replaceAll('m', ''));
      
    } else if (timestamp.endsWith('h')) {
      return int.parse(timestamp.replaceAll('h', '')) * 60; 

    } else if (timestamp.endsWith('d')) {
      return int.parse(timestamp.replaceAll('d', '')) * 1440; 

    } else if (timestamp.endsWith('mo')) {
      return int.parse(timestamp.replaceAll('mo', '')) * 43200; 

    } else if (timestamp.endsWith('y')) {
      return int.parse(timestamp.replaceAll('y', '')) * 525600;

    }

    return 0; 

  }

  static String formatLongDate(String timestamp) {

    final parsedDate = DateTime.parse(timestamp);
    final formattedDate = DateFormat('MMMM d yyyy').format(parsedDate);

    return formattedDate;

  }

  DateTime convertRelativeTimestampToDateTime(String timestamp) {

    if (timestamp == 'Just now') {
      return _dateNow;

    } else if (timestamp.endsWith('m')) {
      return _dateNow.subtract(Duration(minutes: int.parse(timestamp.replaceAll('m', ''))));

    } else if (timestamp.endsWith('h')) {
      return _dateNow.subtract(Duration(hours: int.parse(timestamp.replaceAll('h', ''))));

    } else if (timestamp.endsWith('d')) {
      return _dateNow.subtract(Duration(days: int.parse(timestamp.replaceAll('d', ''))));

    } else if (timestamp.endsWith('mo')) {
      return _dateNow.subtract(Duration(days: int.parse(timestamp.replaceAll('mo', '')) * 30));

    } else if (timestamp.endsWith('y')) {
      return _dateNow.subtract(Duration(days: int.parse(timestamp.replaceAll('y', '')) * 365));

    }

    return _dateNow;

  }
// TODO: Soon, get rid of this fully
  List<String> formatToPostDate({
    required ExtractData data, 
    required String columnName
  }) {
    return data
      .extractStringColumn(columnName)
      .map((timestamp) => formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();
  }

  List<String> formatToPostDate2(List<String> timestampData) {
    return timestampData
      .map((timestamp) => formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();
  }

  static Duration formatTimestampToDuration(String timestamp) {

    final regex = RegExp(r'(\d+)(mo|[hdmy])');
    final match = regex.firstMatch(timestamp);

    if (match == null) return Duration.zero;

    final value = int.parse(match.group(1)!);
    final unit = match.group(2);

    switch (unit) {
      case 'm':
        return Duration(minutes: value);
      case 'h':
        return Duration(hours: value);
      case 'd':
        return Duration(days: value);
      case 'mo':
        return Duration(days: value * 30);
      case 'y':
        return Duration(days: value * 365);
      default:
        return Duration.zero;
    }

  }

}