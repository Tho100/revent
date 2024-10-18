import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/vent_post_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/buttons/actions_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

class VentPreviewer extends StatelessWidget {

  final String title;
  final String bodyText;
  final String creator;
  final String postTimestamp;
  final int totalLikes;
  final int totalComments;
  final Uint8List pfpData;

  const VentPreviewer({
    required this.title,
    required this.bodyText,
    required this.creator,
    required this.postTimestamp,
    required this.totalLikes,
    required this.totalComments,
    required this.pfpData,
    super.key
  });

  void _viewVentPostPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => VentPostPage(
        title: title, 
        bodyText: bodyText, 
        postTimestamp: postTimestamp,
        totalComments: totalComments,
        totalLikes: totalLikes,
        creator: creator, 
        pfpData: pfpData,
      )),
    );
  }

  Widget _buildCommunityAndCreatorHeader() {
    return InkWellEffect(
      onPressed: () => NavigatePage.userProfilePage(username: creator, pfpData: pfpData),
      child: Row(
        children: [
    
          ProfilePictureWidget(
            customWidth: 30,
            customHeight: 30,
            pfpData: pfpData,
          ),
    
          const SizedBox(width: 10),
    
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
    
              Text(
                'motivation',
                style: GoogleFonts.inter(
                  color: ThemeColor.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
    
              const SizedBox(height: 2.5),
    
              Text(
                '@$creator',
                style: GoogleFonts.inter(
                  color: ThemeColor.thirdWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 12
                ),
              ),
    
            ],
          ),
    
          const Spacer(),
    
          Padding(
            padding: const EdgeInsets.only(bottom: 12.5, right: 4.0),
            child: Text(
              postTimestamp,
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontWeight: FontWeight.w800,
                fontSize: 13.2
              ),
            ),
          ),
    
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width-90,
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: ThemeColor.white,
          fontWeight: FontWeight.w800,
          fontSize: 16
        ),
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
    );
  }

  Widget _buildBodyText() {
    return Expanded(
      child: Text(
        bodyText,
        style: GoogleFonts.inter(
          color: ThemeColor.secondaryWhite,
          fontWeight: FontWeight.w800,
          fontSize: 12.5
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2
      ),
    );
  }
  
  Widget _buildLikeButton() {
    return ActionsButton().buildLikeButton(
      text: totalLikes.toString(), 
      onPressed: () => print('Liked')
    );
  }

  Widget _buildCommentButton() {
    return ActionsButton().buildCommentsButton(
      text: totalComments.toString(), 
      onPressed: () => print('Commented')
    );
  }

  @override
  Widget build(BuildContext context) {

    final containerHeight = bodyText.isEmpty ? 160.0 : 221.0;
    final actionButtonsPadding = bodyText.isEmpty ? 0.0 : 22.0;
    final actionButtonsHeightGap = bodyText.isEmpty ? 12.0 : 26.0;

    return InkWellEffect(
      onPressed: () => _viewVentPostPage(),
      child: Container(
        height: containerHeight,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: ThemeColor.thirdWhite,
            width: 0.8
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              _buildCommunityAndCreatorHeader(),
        
              const SizedBox(height: 14),
        
              _buildTitle(context),
        
              const SizedBox(height: 12),
        
              _buildBodyText(),
        
              SizedBox(height: actionButtonsHeightGap),
        
              Padding(
                padding: EdgeInsets.only(top: actionButtonsPadding),
                child: Row(
                  children: [
                        
                    _buildLikeButton(),
                        
                    const SizedBox(width: 8),
                        
                    _buildCommentButton(),
                        
                  ],
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  }

} 