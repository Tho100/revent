import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/buttons/sub_button.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class AccountProfileWidget extends StatelessWidget {

  final String? customText;
  final bool? hideActionButton;

  final String username; 
  final Uint8List pfpData;

  final VoidCallback? onPressed;
  
  const AccountProfileWidget({
    required this.username, 
    required this.pfpData, 
    this.customText,
    this.hideActionButton = false,
    this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWellEffect(
          onPressed: () => NavigatePage.userProfilePage(username: username, pfpData: pfpData),
          child: Row(
              children: [
          
                ProfilePictureWidget(
                  customWidth: 48,
                  customHeight: 48,
                  pfpData: pfpData
                ),
          
                const SizedBox(width: 15),
          
                Text(
                  username,
                  style: GoogleFonts.inter(
                    color: ThemeColor.contentPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                  ),
                ),
          
                const Spacer(),

                if(!hideActionButton! && username != getIt.userProvider.user.username)
                SubButton(
                  customHeight: 40,
                  text: customText ?? 'Follow',
                  onPressed: onPressed ?? () {}
                ),
          
              ],
            ),
        ),

        const SizedBox(height: 22)

      ],
    );
  }

}