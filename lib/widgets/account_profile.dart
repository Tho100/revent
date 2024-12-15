import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/buttons/sub_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

class AccountProfileWidget extends StatelessWidget {

  final String? customText;

  final String username; 
  final Uint8List pfpData;
  
  AccountProfileWidget({
    required this.username, 
    required this.pfpData, 
    this.customText,
    super.key
  });

  final userData = GetIt.instance<UserDataProvider>();

  @override
  Widget build(BuildContext context) {
    return InkWellEffect(
      onPressed: () => NavigatePage.userProfilePage(username: username, pfpData: pfpData),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
      
            ProfilePictureWidget(
              customWidth: 45,
              customHeight: 45,
              pfpData: pfpData
            ),
      
            const SizedBox(width: 10),
      
            Text(
              username,
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
      
            const Spacer(),

            if(username != userData.user.username)
            SubButton(
              customHeight: 40,
              text: customText ?? 'Follow',
              onPressed: () => {}
            ),
      
          ],
        ),
      ),
    );
  }

}