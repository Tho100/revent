import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_title.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class BottomsheetAboutProfile {

  Widget _buildHeaders(String header, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            header,
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
    
          const SizedBox(height: 8),
    
          Text(
            value,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
    
          const SizedBox(height: 20),
    
        ],
      ),
    );
  }

  Future buildBottomsheet({
    required BuildContext context,
    required String username,
    required String pronouns,
    required String joinedDate,
    required int totalVents,
    required Uint8List pfpData
  }) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const SizedBox(height: 12),

        const BottomsheetBar(),

        const BottomsheetTitle(title: 'About this profile'),

        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              ProfilePictureWidget(
                pfpData: pfpData,
                customHeight: 50,
                customWidth: 50,
                customEmptyPfpSize: 25,
              ),
              
              const SizedBox(width: 8),
        
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  _buildHeaders('Name', username),
                  
                  if(pronouns.isNotEmpty)
                  _buildHeaders('Pronouns', pronouns),

                  _buildHeaders('Joined', joinedDate),

                  _buildHeaders('Vents', totalVents.toString())
        
                ],
              )
        
            ],
          ),
        ),
        
        const SizedBox(height: 25),

      ]
    );
  }
  
}