import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class PostTextField {

  Widget buildTitleField({required TextEditingController titleController}) {
    return TextField(
      controller: titleController,
      autofocus: true,
      maxLines: 1,
      maxLength: 85,
      textInputAction: TextInputAction.next,
      style: GoogleFonts.inter(
        color: ThemeColor.contentPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 24
      ),
      decoration: InputDecoration(
        counterText: '',
        hintStyle: GoogleFonts.inter(
          color: ThemeColor.contentThird,
          fontWeight: FontWeight.w800, 
          fontSize: 24
        ),
        hintText: 'Title',
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero, 
      ),
    );
  }  

  Widget buildBodyField({
    required TextEditingController bodyController, 
    bool? autoFocus
  }) { 
    return TextFormField(
      controller: bodyController,
      keyboardType: TextInputType.multiline,
      maxLength: 2850,
      autofocus: autoFocus ?? false,
      maxLines: null,
      style: GoogleFonts.inter(
        color: ThemeColor.contentSecondary,
        fontWeight: FontWeight.w700,
        fontSize: 16
      ),
      decoration: InputDecoration(
        isCollapsed: true,
        counterText: '',
        hintStyle: GoogleFonts.inter(
          color: ThemeColor.contentThird,
          fontWeight: FontWeight.w700, 
          fontSize: 16
        ),
        hintText: 'Body text (optional)',
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero, 
      ),
    );
  }

}