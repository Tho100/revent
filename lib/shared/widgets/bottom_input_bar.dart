import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class BottomInputBar extends StatelessWidget {

  final String hintText;
  final VoidCallback onPressed;

  const BottomInputBar({
    required this.hintText, 
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return InkWellEffect(
      onPressed: onPressed,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ThemeColor.contentThird)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
  
                ProfilePictureWidget(
                  customHeight: 26,
                  customWidth: 26,
                  pfpData: getIt.profileProvider.profile.profilePicture,
                ),
  
                const SizedBox(width: 10),
  
                Text(
                  hintText,
                  style: GoogleFonts.inter(
                    color: ThemeColor.contentThird,
                    fontWeight: FontWeight.w700,
                    fontSize: 14
                  ),
                ),
                
              ],
            ),
          ),
        )
      ),
    );
  }

}