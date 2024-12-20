import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';

class MainTextField extends StatelessWidget {

  final TextEditingController controller;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final bool? autoFocus;
  final bool? readOnly;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;

  const MainTextField({
    required this.controller,
    this.hintText,
    this.maxLength,
    this.maxLines,
    this.autoFocus,
    this.readOnly,
    this.textInputAction,
    this.inputFormatters,
    this.onFieldSubmitted,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      readOnly: readOnly ?? false,
      autofocus: autoFocus ?? false,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      decoration: ThemeStyle.txtFieldStye(hintText: hintText!),
      style: GoogleFonts.inter(
        color: ThemeColor.secondaryWhite,
        fontWeight: FontWeight.w700,
      ),
    );
  }

}