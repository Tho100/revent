import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/general/open_link.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';

class BottomsheetSocialLinks {

  Future<void> _onSocialHandlePressed({
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
          width: MediaQuery.sizeOf(context).width * 0.88,
          child: ElevatedButton(
            onPressed: () async => await _onSocialHandlePressed(platform: platform, handle: handle),
            style: ElevatedButton.styleFrom(
              foregroundColor: ThemeColor.contentThird,
              backgroundColor: ThemeColor.backgroundPrimary,
              side: BorderSide(
                color: ThemeColor.divider,
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
                  child: Icon(icon, color: ThemeColor.contentPrimary, size: platform == 'instagram' ? 23 : 21)
                ),
          
                const SizedBox(width: 10),
          
                Text(
                  "@$handle",
                  style: GoogleFonts.inter(
                    color: ThemeColor.contentPrimary,
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

  bool _isHandleNotEmpty(Map<String, String> handles, String handleType) {
    return (handles[handleType] ?? '').isNotEmpty;
  }

  Future buildBottomsheet({
    required BuildContext context,
    required Map<String, String> handles
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Social Links'),

        if (_isHandleNotEmpty(handles, 'instagram')) 
        _buildSocialButton(
          context: context,
          platform: 'instagram',
          handle: handles['instagram']!,
          icon: FontAwesomeIcons.instagram,
        ),

        if (_isHandleNotEmpty(handles, 'twitter')) 
        _buildSocialButton(
          context: context,
          platform: 'twitter',
          handle: handles['twitter']!,
          icon: FontAwesomeIcons.twitter,
        ),

        if (_isHandleNotEmpty(handles, 'tiktok')) 
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