import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/bottomsheet_widgets/vent_post_actions.dart';
import 'package:revent/widgets/buttons/actions_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

class VentPostPage extends StatefulWidget {

  final String title;
  final String bodyText;
  final String postTimestamp;
  final String creator;
  final int totalLikes;
  final int totalComments;
  final Uint8List pfpData;

  const VentPostPage({
    required this.title,
    required this.bodyText,
    required this.postTimestamp,
    required this.creator,
    required this.totalLikes,
    required this.totalComments,
    required this.pfpData,
    super.key
  });

  @override
  State<VentPostPage> createState() => VentPostPageState();

}

class VentPostPageState extends State<VentPostPage> {

  Widget _buildLikeButton() {
    return ActionsButton().buildLikeButton(
      text: widget.totalLikes.toString(), 
      onPressed: () => print('Liked')
    );
  }

  Widget _buildCommentButton() {
    return ActionsButton().buildCommentsButton(
      text: widget.totalComments.toString(), 
      onPressed: () => print('Commented')
    );
  }

  Widget _buildProfilePicture({required bool isFromCommunity}) {
    return ProfilePictureWidget(
      customHeight: isFromCommunity ? 40 : 35,
      customWidth: isFromCommunity ? 40 : 35,
      pfpData: widget.pfpData,
    );
  }

  Widget _buildProfileHeader() {
    return InkWellEffect(
      onPressed: () => NavigatePage.userProfilePage(username: widget.creator, pfpData: widget.pfpData),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
    
          _buildProfilePicture(isFromCommunity: false),
    
          const SizedBox(width: 10),
    
          Text(
            '@${widget.creator}',
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 14.5
            ),
          ),
    
          Text(
            '  •  ${widget.postTimestamp}',
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 14.5
            ),
          ),
        
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SelectableText(
          widget.title,
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w800,
            fontSize: 21
          ),
          maxLines: 2,
        ),

        SelectableText(
          widget.bodyText,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w800,
            fontSize: 14
          ),
        ),

      ],
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
        leading: IconButton(
        icon: const Icon(CupertinoIcons.chevron_back, color: ThemeColor.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          _buildProfilePicture(isFromCommunity: true),

          const SizedBox(width: 12),
    
          Text(
            'parenting-support',
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            )
          ),

        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.ellipsis_vertical, size: 22),
          onPressed: () => BottomsheetVentPostActions().buildBottomsheet(
            context: context, 
            reportOnPressed: () {}, 
            blockOnPressed: () {}
          )
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {

    final actionButtonsPadding = widget.bodyText.isEmpty ? 0.0 : 22.0;
    final actionButtonsHeightGap = widget.bodyText.isEmpty ? 0.0 : 26.0;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 24, left: 18),
        child: SizedBox(
          width: MediaQuery.of(context).size.width-45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              _buildProfileHeader(),

              const SizedBox(height: 18),

              _buildHeader(),

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

            ] 
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(context),
      body: _buildBody(context),
    );
  }

}