import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class BottomsheetAboutProfile {

  String _shortenDate(String originalDate) {

    final parsed = DateFormat('MMMM d yyyy').parse(originalDate);
    
    return DateFormat('MMM d yyyy').format(parsed);

  }

  Widget _buildHeaders(String header, String value) {
    return Column(
      children: [
        
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
      
      ],
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
    return Hero(
      tag: 'profile-picture-hero',
      child: ProfilePictureWidget(
        pfpData: pfpData,
        customHeight: 100,
        customWidth: 100,
        customEmptyPfpSize: 40,
      ),
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required String username,
    required String pronouns,
    required String joinedDate,
    required Uint8List pfpData
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'About Profile'),

        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            children: [
              
              _buildProfilePicture(pfpData),
              
              const SizedBox(height: 16),
              
              _buildUsername(username),
              
              const SizedBox(height: 35),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
              
                    if (pronouns.isNotEmpty)
                    Expanded(
                      child: _buildHeaders('Pronouns', pronouns),
                    ),
              
                    const SizedBox(width: 25),
              
                    Container(
                      width: 1,
                      height: 32,
                      color: ThemeColor.divider,
                    ),
              
                    const SizedBox(width: 25),
              
                    Expanded(
                      child: _buildHeaders('Joined', _shortenDate(joinedDate)),
                    ),
                    
                  ],
                ),
              ),

            ],
          ),
        ),
                
        const SizedBox(height: 65),

      ]
    );
  }
  
}