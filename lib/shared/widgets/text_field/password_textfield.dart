import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/input_formatters.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';

class PasswordTextField extends StatefulWidget {

  final TextEditingController controller;
  final String hintText;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
  
}

class _PasswordTextFieldState extends State<PasswordTextField> {

  bool _isObscureText = false;

  void _toggleObscureText() => setState(() => _isObscureText = !_isObscureText);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.inter(
        color: ThemeColor.contentSecondary,
        fontWeight: FontWeight.w700,
      ),
      inputFormatters: InputFormatters.passwordFormatter(),
      controller: widget.controller,
      obscureText: !_isObscureText,
      decoration: ThemeStyle.txtFieldStye(
        hintText: widget.hintText,
        customSuffix: IconButton(
          icon: Icon(
            _isObscureText ? Icons.visibility : Icons.visibility_off, 
            color: ThemeColor.contentThird,
          ),
          onPressed: _toggleObscureText,
        ),
      ),
    );
  }

}
