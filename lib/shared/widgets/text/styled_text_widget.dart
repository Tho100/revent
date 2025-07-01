import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/open_link.dart';
import 'package:revent/shared/themes/theme_color.dart';

class StyledTextWidget extends StatelessWidget {

  final String text;
  final bool isPreviewer;
  final bool? isSelectable;

  const StyledTextWidget({
    required this.text, 
    this.isPreviewer = false,
    this.isSelectable = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    final textStyle = GoogleFonts.inter(
      color: ThemeColor.contentSecondary,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );

    if (isSelectable!) {
      return SelectableText.rich(
        TextSpan(
          children: _buildTextSpans(text),
          style: textStyle
        ),
      );

    } else {
      return RichText(
        maxLines: isPreviewer ? 3 : null,
        overflow: isPreviewer ? TextOverflow.ellipsis : TextOverflow.clip,
        text: TextSpan(
          children: _buildTextSpans(text),
          style: textStyle
        ),
      );

    }

  }

  bool _isMentionOrUrl(String word) {

    if (word.startsWith('@')) {
      return true;
    }

    if (OpenLink(url: word).isValidUrl()) {
      return true;
    }

    return false;

  }

  List<String> _getTextChunks({
    required String text, 
    required int index, 
    required int end, 
    required int symbolLength
  }) {

    final regex = RegExp(r'(\s+|[^\s]+)');
    
    final content = text.substring(index + symbolLength, end);

    return regex.allMatches(content).map((m) => m.group(0)!).toList();

  }

  Map<String, TextSpan> _blueTextSpan(String text) {

    final blueTextStyle = isPreviewer 
      ? GoogleFonts.inter(
        color: Colors.blueAccent,
        fontWeight: FontWeight.w800,
        fontSize: 14
      )
      : const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      );

    TapGestureRecognizer? mentionRecognizer;
    TapGestureRecognizer? urlRecognizer;

    if (!isPreviewer) {

      mentionRecognizer = TapGestureRecognizer()
        ..onTap = () => NavigatePage.userProfilePage(username: text);

      urlRecognizer = TapGestureRecognizer()
        ..onTap = () async => await OpenLink(url: text).open();
        
    }

    return {
      'mention': TextSpan(
        text: text,
        style: blueTextStyle,
        recognizer: mentionRecognizer
      ),
      'link': TextSpan(
        text: text,
        style: blueTextStyle,
        recognizer: urlRecognizer
      )
    };

  }

  List<TextSpan> _buildTextSpans(String text) {

    final spans = <TextSpan>[];

    final italicTextStyle = isPreviewer
      ? GoogleFonts.inter(
        color: ThemeColor.contentSecondary,
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.italic,
        fontSize: 13
      )
      : const TextStyle(
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        fontSize: 14,
      );

    final boldTextStyle = isPreviewer
      ? GoogleFonts.inter(
        color: ThemeColor.contentSecondary,
        fontWeight: FontWeight.w900,
        fontSize: 13
      )  
      : const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 14,
      );

    final strikeTextStyle = isPreviewer
    ? GoogleFonts.inter(
      color: ThemeColor.contentSecondary,
      fontWeight: FontWeight.w800,
      decoration: TextDecoration.lineThrough,
      fontSize: 13
    )  
    : const TextStyle(
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.lineThrough,
      fontSize: 14,
    );

    const boldMarker = '**';
    const italicMarker = '*';
    const strikeMarker = '~~';

    int i = 0;

    while (i < text.length) {

      if (text.startsWith(boldMarker, i)) {
        
        int end = text.indexOf(boldMarker, i + 2);

        if (end == -1) end = text.length;

        final textChunks = _getTextChunks(text: text, index: i, end: end, symbolLength: 2);

        for (var text in textChunks) {

          if (text.isEmpty) {
            spans.add(const TextSpan(text: ' '));
            continue;
          }

          if (_isMentionOrUrl(text)) {

            if (text.startsWith('@')) {

              spans.add(
                _blueTextSpan(text)['mention']!
              );

            } else {

              spans.add(
                _blueTextSpan(text)['link']!
              );

            }

          } else {
            spans.add(
              TextSpan(text: text, style: boldTextStyle)
            );
          }

        }

        i = end + 2;
        
      } else if (text.startsWith(italicMarker, i)) {

        int end = text.indexOf(italicMarker, i + 1);

        if (end == -1) end = text.length;

        final textChunks = _getTextChunks(text: text, index: i, end: end, symbolLength: 1);

        for (var text in textChunks) {

          if (text.isEmpty) {
            spans.add(const TextSpan(text: ' '));
            continue;
          }

          if (_isMentionOrUrl(text)) {
            
            if (text.startsWith('@')) {

              spans.add(
                _blueTextSpan(text)['mention']!
              );

            } else {

              spans.add(
                _blueTextSpan(text)['link']!
              );

            }

          } else {
            spans.add(
              TextSpan(text: text, style: italicTextStyle)
            );
          }

        }

        i = end + 1;

      } else if (text.startsWith(strikeMarker, i)) {

        int end = text.indexOf(strikeMarker, i + 2);

        if (end == -1) end = text.length;

        final textChunks = _getTextChunks(text: text, index: i, end: end, symbolLength: 2);

        for (var text in textChunks) {

          if (text.isEmpty) {
            spans.add(const TextSpan(text: ' '));
            continue;
          }

          if (_isMentionOrUrl(text)) {
            
            if (text.startsWith('@')) {

              spans.add(
                _blueTextSpan(text)['mention']!
              );

            } else {

              spans.add(
                _blueTextSpan(text)['link']!
              );

            }

          } else {
            spans.add(
              TextSpan(text: text, style: strikeTextStyle)
            );
          }

        }

        i = end + 2;

      } else {

        final nextIndexes = [
          text.indexOf('**', i),
          text.indexOf('*', i),
          text.indexOf('~~', i),
        ].where((pos) => pos != -1).toList();

        final nextPos = nextIndexes.isEmpty ? text.length : nextIndexes.reduce((a, b) => a < b ? a : b);
        final chunk = text.substring(i, nextPos);

        final textChunks = RegExp(r'(\s+|[^\s]+)').allMatches(chunk).map((m) => m.group(0)!).toList();

        for (var text in textChunks) {
          
          if (text.isEmpty) {
            spans.add(const TextSpan(text: ' '));
            continue;
          }

          if (text.startsWith('@')) {

            spans.add(
              _blueTextSpan(text)['mention']!
            );

          } else if (OpenLink(url: text).isValidUrl()) {

            spans.add(
              _blueTextSpan(text)['link']!
            );

          } else {
            spans.add(
              TextSpan(
                text: text, 
                  style: isPreviewer
                    ? GoogleFonts.inter(
                      color: ThemeColor.contentSecondary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13
                    )
                    : null
              ),
            );
          }

        }

        i = nextPos;

      }
      
    }

    return spans;
    
  }

}