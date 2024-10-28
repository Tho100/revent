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

  String formatLongDate(String timestamp) {

    final parsedDate = DateTime.parse(timestamp);
    final formattedDate = DateFormat('MMMM d yyyy').format(parsedDate);

    return formattedDate;

  }

}