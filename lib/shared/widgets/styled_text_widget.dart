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

  // TODO: Checkout to refactor and improve this code 

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

    const blueTextStyle = TextStyle(
      color: Colors.blueAccent,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );

    bool isMentionOrUrl(String word) {
      if (word.startsWith('@')) return true;
      if (OpenLink(url: word).isValidUrl()) return true;
      return false;
    }

    int i = 0;

    while (i < text.length) {

      if (text.startsWith('**', i)) {
        
        int end = text.indexOf('**', i + 2);

        if (end == -1) end = text.length;

        final content = text.substring(i + 2, end);

        final words = RegExp(r'(\s+|[^\s]+)').allMatches(content).map((m) => m.group(0)!).toList();

        for (var word in words) {

          if (word.isEmpty) {
            spans.add(const TextSpan(text: ' '));
            continue;
          }

          if (isMentionOrUrl(word)) {

            if (word.startsWith('@')) {

              final mentioned = word.substring(1);

              spans.add(TextSpan(
                text: word ,
                style: blueTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => NavigatePage.userProfilePage(username: mentioned),
              ));

            } else {

              spans.add(TextSpan(
                text: word,
                style: blueTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async => await OpenLink(url: word).open(),
              ));
            }
          } else {
            spans.add(
              TextSpan(text: word, style: boldTextStyle)
            );
          }

        }

        i = end + 2;
        
      } else if (text.startsWith('*', i)) {

        int end = text.indexOf('*', i + 1);

        if (end == -1) end = text.length;
        final content = text.substring(i + 1, end);

        final words = RegExp(r'(\s+|[^\s]+)').allMatches(content).map((m) => m.group(0)!).toList();

        for (var word in words) {

          if (word.isEmpty) {
            spans.add(const TextSpan(text: ' '));
            continue;
          }

          if (isMentionOrUrl(word)) {
            
            if (word.startsWith('@')) {

              final mentioned = word.substring(1);

              spans.add(
                TextSpan(
                text: word,
                style: blueTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => NavigatePage.userProfilePage(username: mentioned),
              ));

            } else {

              spans.add(
                TextSpan(
                text: word,
                style: blueTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async => await OpenLink(url: word).open(),
              ));

            }

          } else {
            spans.add(
              TextSpan(text: word, style: italicTextStyle)
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

        final words = RegExp(r'(\s+|[^\s]+)').allMatches(chunk).map((m) => m.group(0)!).toList();

        for (var word in words) {
          
          if (word.isEmpty) {
            spans.add(const TextSpan(text: ' '));
            continue;
          }

          if (word.startsWith('@')) {

            final mentioned = word.substring(1);

            spans.add(
              TextSpan(
              text: word,
              style: blueTextStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () => NavigatePage.userProfilePage(username: mentioned),
            ));

          } else if (OpenLink(url: word).isValidUrl()) {

            spans.add(
              TextSpan(
              text: word,
              style: blueTextStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () async => await OpenLink(url: word).open(),
            ));

          } else {
            spans.add(
              TextSpan(text: word)
            );
          }

        }

        i = nextPos;
      }
      
    }

    return spans;
    
  }

}