import 'package:revent/global/validation_limits.dart';

class FormatPreviewerBody {

  static String formatBodyText({
    required String bodyText, 
    required bool isNsfw
  }) {
    
    if (isNsfw) return '';

    if (bodyText.length >= ValidationLimits.maxBodyPreviewerLength) {
      return '${bodyText.substring(0, bodyText.length - 3)}...';
    }

    return bodyText;

  }

}