import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/open_link.dart';
import 'package:revent/shared/themes/theme_color.dart';

class StyledTextWidget extends StatelessWidget {

  final String text;
  final bool? isSelectable;

  const StyledTextWidget({
    required this.text, 
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
        text: TextSpan(
          children: _buildTextSpans(text),
          style: textStyle
        ),
      );

    }

  }

  bool _isMentionOrUrl(String word) {

    if(word.startsWith('@')) {
      return true;
    }

    if(OpenLink(url: word).isValidUrl()) {
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

    const blueTextStyle = TextStyle(
      color: Colors.blueAccent,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );

    return {
      'mention': TextSpan(
        text: text,
        style: blueTextStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () => NavigatePage.userProfilePage(username: text)
      ),
      'link': TextSpan(
        text: text,
        style: blueTextStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () async => await OpenLink(url: text).open()
      )
    };

  }

  List<TextSpan> _buildTextSpans(String text) {

    final spans = <TextSpan>[];

    const italicTextStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
      fontSize: 14,
    );

    const boldTextStyle = TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 14,
    );

    int i = 0;

    while (i < text.length) {

      if (text.startsWith('**', i)) {
        
        int end = text.indexOf('**', i + 2);

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
        
      } else if (text.startsWith('*', i)) {

        int end = text.indexOf('*', i + 1);

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

      } else {

        final nextIndexes = [
          text.indexOf('**', i),
          text.indexOf('*', i),
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
              TextSpan(text: text)
            );
          }

        }

        i = nextPos;

      }
      
    }

    return spans;
    
  }

}