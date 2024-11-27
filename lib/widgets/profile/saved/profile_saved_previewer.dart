import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_query/user_profile/profile_posts_getter.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/pages/vent/vent_post_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer_widgets.dart';

class ProfileSavedPreviewer extends StatelessWidget {

  final bool isMyProfile;

  final String username;
  final String title;

  final int totalLikes;
  final int totalComments;
  final String postTimestamp;

  final Uint8List pfpData;

  const ProfileSavedPreviewer({
    required this.isMyProfile,
    required this.username,
    required this.title,
    required this.totalLikes,
    required this.totalComments,
    required this.postTimestamp,
    required this.pfpData,
    super.key
  });

  void _viewVentPostPage() async {

    final ventDataInfo = await ProfilePostsDataGetter().getBodyText(
      title: title, creator: username
    );

    final bodyText = ventDataInfo['body_text'];

    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => VentPostPage(
        title: title, 
        bodyText: bodyText, 
        postTimestamp: postTimestamp,
        totalLikes: totalLikes,
        creator: username, 
        pfpData: pfpData,
      )),
    );

  }

  Widget _buildLikesAndCommentsInfo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [

          const Icon(CupertinoIcons.heart_fill, color: ThemeColor.likedColor, size: 18.5),

          const SizedBox(width: 6),

          Text(
            totalLikes.toString(),
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
            textAlign: TextAlign.start,
          ),

          const SizedBox(width: 18),

          const Icon(CupertinoIcons.chat_bubble, color: ThemeColor.white, size: 18.5),
  
          const SizedBox(width: 6), 
  
          Text(
            totalComments.toString(),
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildVentPreview() {

    final ventPreviewer = VentPreviewerWidgets(
      context: navigatorKey.currentContext!,
      title: title,
      bodyText: '',
      creator: username,
      pfpData: pfpData,
      postTimestamp: postTimestamp,
      viewVentPostOnPressed: () => _viewVentPostPage(),
      reportOnPressed: () {},
      blockOnPressed: () {},
      removeSavedOnPressed: isMyProfile 
        ? () async {
        await CallVentActions(
          context: navigatorKey.currentContext!, 
          title: title, 
          creator: username
        ).removeSavedPost();
      } : null 
    );

    return ventPreviewer.buildMainContainer(
      children: [
        
        Row(
          children: [

            ventPreviewer.buildHeaders(),

            const Spacer(),

            ventPreviewer.buildVentOptionsButton(),

          ]
        ),

        const SizedBox(height: 14),

        ventPreviewer.buildTitle(),

        const SizedBox(height: 25), 

        _buildLikesAndCommentsInfo(),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildVentPreview();
  }

}