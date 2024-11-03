import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/pages/vent_post_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/vent_query/vent_data_getter.dart';
import 'package:revent/widgets/inkwell_effect.dart';

class ProfilePostsPreviewer extends StatelessWidget {

  final String username;
  final String title;

  final int totalLikes;
  final Uint8List pfpData;

  const ProfilePostsPreviewer({
    required this.username,
    required this.title,
    required this.totalLikes,
    required this.pfpData,
    super.key
  });

  void _viewVentPostPage() async {

    final ventDataInfo = await VentDataGetter()
      .getProfilePostsVentData(title: title, creator: username);

    final bodyText = ventDataInfo['body_text'];
    final postTimestamp = ventDataInfo['post_timestamp'];
    final totalComments = ventDataInfo['total_comments'];

    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => VentPostPage(
        title: title, 
        bodyText: bodyText, 
        postTimestamp: postTimestamp,
        totalComments: totalComments,
        totalLikes: totalLikes,
        creator: username, 
        pfpData: pfpData,
      )),
    );

  }

  Widget _buildChild() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    
          SizedBox(
            height: 150,
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 16
              ),
              textAlign: TextAlign.start,
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [

                  const Icon(CupertinoIcons.heart_fill, color: ThemeColor.likedColor, size: 17),
                  
                  const SizedBox(width: 6),

                  Text(
                    totalLikes.toString(),
                    style: GoogleFonts.inter(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14
                    ),
                    textAlign: TextAlign.start,
                  ),

                  const Spacer(),

                  const Icon(CupertinoIcons.chevron_right, color: ThemeColor.thirdWhite, size: 17),

                ],
              )
            ),
          )
    
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWellEffect(
      onPressed: () => _viewVentPostPage(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: ThemeColor.thirdWhite,
            width: 0.8
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: _buildChild()
      ),
    );
  }

}