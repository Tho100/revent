import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';

class AuthTextField {
  
  Widget passwordTextField({
    required TextEditingController controller,
    required ValueNotifier<bool> visibility,
    required String hintText,    
  }) {
    return ValueListenableBuilder(
      valueListenable: visibility,
      builder: (context, value, child) {
        return TextFormField(
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w700,
          ),
          controller: controller,
          obscureText: !value,
          decoration: ThemeStyle.txtFieldStye(
            hintText: hintText,
            customSuffix: IconButton(
              icon: Icon(value ? Icons.visibility : Icons.visibility_off,
                color: ThemeColor.thirdWhite,
              ), 
              onPressed: () => visibility.value = !visibility.value,
            ),
          ),
        );
      },
    );
  }

}