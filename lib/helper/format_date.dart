import 'package:intl/intl.dart';

class FormatDate {

  String formatPostTimestamp(DateTime createdAt) {

    final now = DateTime.now();
    final difference = now.difference(createdAt);

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

  int parseFormattedTimestamp(String timestamp) {

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

  String formatLongDate(String timestamp) {

    final parsedDate = DateTime.parse(timestamp);
    final formattedDate = DateFormat('MMMM d yyyy').format(parsedDate);

    return formattedDate;

  }

}