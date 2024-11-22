import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/pages/vent_post_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/vent_query/vent_data_getter.dart';
import 'package:revent/widgets/bottomsheet_widgets/vent_post_actions.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

// TODO: Create separated class for ventpreviewer widgets 

class ProfilePostsPreviewer extends StatelessWidget {

  final String username;
  final String title;

  final int totalLikes;
  final int totalComments;
  final String postTimestamp;

  final Uint8List pfpData;

  const ProfilePostsPreviewer({
    required this.username,
    required this.title,
    required this.totalLikes,
    required this.totalComments,
    required this.postTimestamp,
    required this.pfpData,
    super.key
  });

  void _viewVentPostPage() async {

    final ventDataInfo = await VentDataGetter().getProfilePostsVentData(
      title: title, creator: username
    );

    final bodyText = ventDataInfo['body_text'];

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
  
  Widget _buildVentOptionsButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: SizedBox(
        width: 25,
        height: 25,
        child: IconButton(
          onPressed: () => BottomsheetVentPostActions().buildBottomsheet(
            context: navigatorKey.currentContext!, 
            creator: username,
            saveOnPressed: () {
              Navigator.pop(navigatorKey.currentContext!);
            },
            reportOnPressed: () {
              Navigator.pop(navigatorKey.currentContext!);
            }, 
            blockOnPressed: () {
              Navigator.pop(navigatorKey.currentContext!);
            },
          ),
          icon: Transform.translate(
            offset: const Offset(0, -10),
            child: const Icon(CupertinoIcons.ellipsis, color: ThemeColor.thirdWhite, size: 18)
          )
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
  
        ProfilePictureWidget(
          customWidth: 30,
          customHeight: 30,
          pfpData: pfpData,
        ),
  
        const SizedBox(width: 8),
  
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Text(
            '@$username',
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w800,
              fontSize: 14
            ),
          ),
        ),
  
        const SizedBox(width: 8),
  
        Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text(
            postTimestamp,
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 13
            ),
          ),
        ),
  
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontWeight: FontWeight.w800,
        fontSize: 16,
      ),
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
      maxLines: 7,
    );
  }

  Widget _buildActionButtons() {
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

  Widget _buildChild() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              _buildHeader(),

              const Spacer(),

              _buildVentOptionsButton(),

            ]
          ),

          const SizedBox(height: 14),

          _buildTitle(),

          const SizedBox(height: 25), 

          _buildActionButtons(),

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
            color: ThemeColor.lightGrey,
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: _buildChild(),
      ),
    );
  }

}