import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class BodyTextField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final int maxLength;

  const BodyTextField({
    required this.controller, 
    required this.hintText,
    this.maxLength = 1000,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 8),
      child: TextFormField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        maxLength: maxLength,
        maxLines: null,
        style: GoogleFonts.inter(
          color: ThemeColor.contentSecondary,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          isCollapsed: true, 
          counterText: '',
          hintStyle: GoogleFonts.inter(
            color: ThemeColor.contentThird,
            fontWeight: FontWeight.w700, 
            fontSize: 14
          ),
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero, 
        ),
      ),
    );
  }

}