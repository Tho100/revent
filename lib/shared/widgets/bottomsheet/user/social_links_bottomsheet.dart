import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/open_link.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';

class BottomsheetSocialLinks {

  Future<void> _socialHandleOnPressed({
    required String platform, 
    required String handle
  }) async {

    final socialUrl = {
      'instagram': 'https://instagram.com/$handle/',
      'twitter': 'https://twitter.com/$handle',
      'tiktok': 'https://tiktok.com/@$handle',
    };

    await OpenLink(url: socialUrl[platform]!).open();

  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String platform,
    required IconData icon,
    required String handle
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Center(
        child: SizedBox(
          height: 65,
          width: MediaQuery.of(context).size.width * 0.88,
          child: ElevatedButton(
            onPressed: () async => await _socialHandleOnPressed(platform: platform, handle: handle),
            style: ElevatedButton.styleFrom(
              foregroundColor: ThemeColor.thirdWhite,
              backgroundColor: ThemeColor.black,
              side: const BorderSide(
                color: ThemeColor.lightGrey,
                width: 1
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(width: 2),
          
                Transform.translate(
                  offset: const Offset(0, -1),
                  child: Icon(icon, color: ThemeColor.white, size: platform == 'instagram' ? 23 : 21)
                ),
          
                const SizedBox(width: 10),
          
                Text(
                  "@$handle",
                  style: GoogleFonts.inter(
                    color: ThemeColor.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.start,
                ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required Map<String, String> handles
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'Social Links'),

        if (handles['instagram']!.isNotEmpty) 
        _buildSocialButton(
          context: context,
          platform: 'instagram',
          handle: handles['instagram']!,
          icon: FontAwesomeIcons.instagram,
        ),

        if (handles['twitter']!.isNotEmpty) 
        _buildSocialButton(
          context: context,
          platform: 'twitter',
          handle: handles['twitter']!,
          icon: FontAwesomeIcons.twitter,
        ),

        if (handles['tiktok']!.isNotEmpty) 
        _buildSocialButton(
          context: context,
          platform: 'tiktok',
          handle: handles['tiktok']!,
          icon: FontAwesomeIcons.tiktok,
        ),

        const SizedBox(height: 25),

      ]
    );
  }

}