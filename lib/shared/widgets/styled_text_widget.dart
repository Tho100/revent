import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
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
      color: ThemeColor.secondaryWhite,
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

  List<TextSpan> _buildTextSpans(String text) {

    final words = text.split(' ');

    return words.map((word) {

      if (word.startsWith('@')) {

        final mentioned = word.substring(1);

        return TextSpan(
          text: '$word ',
          style: const TextStyle(
            color: Colors.blueAccent,       
            fontWeight: FontWeight.w700,
            fontSize: 14
          ),
          recognizer: TapGestureRecognizer()..onTap = () => NavigatePage.userProfilePage(
            username: mentioned, 
            pfpData: Uint8List(0)
          )
        );

      } else {
        return TextSpan(
          text: '$word ',
        );

      }

    }).toList();

  }

}