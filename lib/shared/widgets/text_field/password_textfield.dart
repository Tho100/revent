import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/input/input_formatters.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';

class PasswordTextField extends StatefulWidget {

  final TextEditingController controller;
  final String hintText;
  final Iterable<String>? autoFillHints;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.autoFillHints,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
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
      keyboardType: TextInputType.visiblePassword,
      inputFormatters: InputFormatters.passwordFormatter(),
      controller: widget.controller,
      obscureText: !_isObscureText,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autoFillHints,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
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