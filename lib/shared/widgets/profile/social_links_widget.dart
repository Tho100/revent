import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/user/social_links_bottomsheet.dart';

class SocialLinksWidgets {

  final Map<String, String> socialHandles;

  SocialLinksWidgets({required this.socialHandles});

  Widget buildSocialLinks() {
    return GestureDetector(
      onTap: () {
        BottomsheetSocialLinks().buildBottomsheet(
          context: navigatorKey.currentContext!, 
          handles: socialHandles
        );
      },
      child: Row(
        children: [
    
          if (socialHandles.containsKey('tiktok') &&
            socialHandles['tiktok']?.isNotEmpty == true)
          _buildSocialLinksIcon(
            'tiktok', 
            socialHandles['tiktok']!,
            FontAwesomeIcons.tiktok, 19
          ),
    
          if (socialHandles.containsKey('twitter') &&
            socialHandles['twitter']?.isNotEmpty == true)
          _buildSocialLinksIcon(
            'twitter', 
            socialHandles['twitter']!,
            FontAwesomeIcons.twitter, 21
          ),
    
          if (socialHandles.containsKey('instagram') &&
            socialHandles['instagram']?.isNotEmpty == true)
          _buildSocialLinksIcon(
            'instagram', 
            socialHandles['instagram']!, 
            FontAwesomeIcons.instagram, 22
          ),
    
        ],
      ),
    );
  }

  Widget _buildSocialLinksIcon(String platform, String handle, IconData icon, double size) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 2.0),
      child: FaIcon(icon, size: size, color: ThemeColor.contentPrimary),
    );
  }

}