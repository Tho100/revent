import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/input_formatters.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';

class AuthTextField extends StatefulWidget { // TODO: Rename to passwordtextfield

  final TextEditingController controller;
  final String hintText;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<AuthTextField> createState() => _AuthPasswordFieldState();
  
}

class _AuthPasswordFieldState extends State<AuthTextField> {

  bool _isObscureText = false;

  void _toggleVisibility() {
    setState(
      () => _isObscureText = !_isObscureText
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.inter(
        color: ThemeColor.contentSecondary,
        fontWeight: FontWeight.w700,
      ),
      inputFormatters: InputFormatters.noSpaces(),
      controller: widget.controller,
      obscureText: !_isObscureText,
      decoration: ThemeStyle.txtFieldStye(
        hintText: widget.hintText,
        customSuffix: IconButton(
          icon: Icon(
            _isObscureText ? Icons.visibility : Icons.visibility_off,
            color: ThemeColor.contentThird,
          ),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}
