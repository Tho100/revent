import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';

class MainTextField extends StatelessWidget {

  final TextEditingController controller;
  final String? initialValue;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final bool? autoFocus;
  final List<TextInputFormatter>? inputFormatters;

  const MainTextField({
    required this.controller,
    this.initialValue,
    this.hintText,
    this.maxLength,
    this.maxLines,
    this.autoFocus,
    this.inputFormatters,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      autofocus: autoFocus ?? false,
      inputFormatters: inputFormatters,
      decoration: ThemeStyle.txtFieldStye(hintText: hintText!),
      style: GoogleFonts.inter(
        color: ThemeColor.secondaryWhite,
        fontWeight: FontWeight.w700,
      ),
    );
  }

}