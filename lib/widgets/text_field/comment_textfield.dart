import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class CommentTextField extends StatelessWidget {

  final TextEditingController controller;

  const CommentTextField({
    required this.controller, 
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -8),
      child: TextFormField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        maxLength: 1000,
        maxLines: null,
        style: GoogleFonts.inter(
          color: ThemeColor.secondaryWhite,
          fontWeight: FontWeight.w800,
          fontSize: 16
        ),
        decoration: InputDecoration(
          counterText: '',
          hintStyle: GoogleFonts.inter(
            color: ThemeColor.thirdWhite,
            fontWeight: FontWeight.w800, 
            fontSize: 16
          ),
          hintText: 'Your comment',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero, 
        ),
      ),
    );
  }

}