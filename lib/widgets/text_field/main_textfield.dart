import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';

class MainTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final int? maxLength;
  final bool? autoFocus;

  const MainTextField({
    required this.controller,
    required this.hintText,
    this.maxLength,
    this.autoFocus,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      autofocus: autoFocus ?? false,
      decoration: ThemeStyle.txtFieldStye(hintText: hintText),
      style: GoogleFonts.inter(
        color: ThemeColor.secondaryWhite,
        fontWeight: FontWeight.w700,
      ),
    );
  }

}