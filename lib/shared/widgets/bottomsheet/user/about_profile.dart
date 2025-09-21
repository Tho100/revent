import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:revent/global/app_keys.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/pages/profile_picture_viewer_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/boredered_container.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class BottomsheetAboutProfile {

  String _shortenDate(String originalDate) {

    final parsed = DateFormat('MMMM d yyyy').parse(originalDate);
    
    return DateFormat('MMM d yyyy').format(parsed);

  }

  String _getTimeAgoDate(String originalDate) {

    final parsedDate = DateFormat('MMMM d yyyy').parse(originalDate);

    return FormatDate().formatPostTimestamp(parsedDate);

  }

  Widget _buildHeaders(String header, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0),
      child: Row(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 8),
              
              Text(
                header,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentThird,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
    
              const SizedBox(height: 8),
    
              Text(
                value,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
    
              const SizedBox(height: 8),
    
            ],
          ),

          const Spacer(),

        ],
      ),
    );
  }

  Widget _buildUsername(String username) {
    return Text(
      username,
      style: GoogleFonts.inter(
        color: ThemeColor.contentPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProfilePicture(Uint8List pfpData) {
    return InkWellEffect(
      onPressed: () {
        Navigator.push(
          AppKeys.navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => ProfilePictureViewer(pfpData: pfpData)
          )
        );
      },
      child: Hero(
        tag: 'profile-picture-hero',
        child: ProfilePictureWidget(
          pfpData: pfpData,
          customHeight: 100,
          customWidth: 100,
          customEmptyPfpSize: 40,
        ),
      ),
    );
  }

  Widget _buildJoinedDate(String joinedDate) {

    final parsedDate = DateFormat('MMMM d yyyy').parse(joinedDate);
    final difference = DateTime.now().difference(parsedDate).inDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        _buildHeaders('Joined', _shortenDate(joinedDate)),

        if (difference > 2) ... [
          
          Transform.translate(
            offset: const Offset(0, -2),
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0),
              child: Text(
                '${_getTimeAgoDate(joinedDate)} ago',
                style: GoogleFonts.inter(
                  color: ThemeColor.contentSecondary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13
                ),
              ),
            ),
          ),

          const SizedBox(height: 5)

        ]

      ],
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required String username,
    required String pronouns,
    required String country,
    required String joinedDate,
    required Uint8List pfpData
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'About Profile'),

        Column(
          children: [
            
            _buildProfilePicture(pfpData),
            
            const SizedBox(height: 16),
            
            _buildUsername(username),
            
            const SizedBox(height: 15),
            
            BorderedContainer(
              child: _buildJoinedDate(joinedDate)
            ),
              
            if (pronouns.isNotEmpty)
            BorderedContainer(
              child: _buildHeaders('Pronouns', pronouns)
            ),

            if (country.isNotEmpty)
            BorderedContainer(
              child: _buildHeaders('Country', country)
            ),

          ],
          
        ),
                
        const SizedBox(height: 35),

      ]
    );
  }
  
}