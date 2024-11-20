import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/vent_post_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/bottomsheet_widgets/vent_post_actions.dart';
import 'package:revent/widgets/buttons/actions_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

class VentPreviewer extends StatefulWidget {

  final String title;
  final String bodyText;
  final String creator;
  final String postTimestamp;
  final int totalLikes;
  final int totalComments;
  final Uint8List pfpData;
  final bool isPostLiked;

  const VentPreviewer({
    required this.title,
    required this.bodyText,
    required this.creator,
    required this.postTimestamp,
    required this.totalLikes,
    required this.totalComments,
    required this.pfpData,
    required this.isPostLiked,
    super.key
  });

  @override
  State<VentPreviewer> createState() => VentPreviewerState();

}

class VentPreviewerState extends State<VentPreviewer> {

  void _viewVentPostPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => VentPostPage(
        title: widget.title, 
        bodyText: widget.bodyText, 
        postTimestamp: widget.postTimestamp,
        totalComments: widget.totalComments,
        totalLikes: widget.totalLikes,
        creator: widget.creator, 
        pfpData: widget.pfpData,
      )),
    );
  }

  Widget _buildLikeButton() {
    return ActionsButton().buildLikeButton(
      text: widget.totalLikes.toString(), 
      isLiked: widget.isPostLiked,
      onPressed: () async {
        await CallVentActions(
          context: context, 
          title: widget.title, 
          creator: widget.creator
        ).likePost();
      }
    );
  }

  Widget _buildCommentButton() {
    return ActionsButton().buildCommentsButton(
      text: widget.totalComments.toString(), 
      onPressed: () => _viewVentPostPage()
    );
  }

  Widget _buildSaveButton() {
    return ActionsButton().buildSaveButton(
      onPressed: () => print('Saved')
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
            context: context, 
            creator: widget.creator,
            saveOnPressed: () {
              Navigator.pop(context);
            },
            reportOnPressed: () {
              Navigator.pop(context);
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

  Widget _buildCommunityAndCreatorHeader() {
    return InkWellEffect(
      onPressed: () => NavigatePage.userProfilePage(username: widget.creator, pfpData: widget.pfpData),
      child: Row(
        children: [
    
          ProfilePictureWidget(
            customWidth: 30,
            customHeight: 30,
            pfpData: widget.pfpData,
          ),
    
          const SizedBox(width: 8),
    
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              '@${widget.creator}',
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
              widget.postTimestamp,
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontWeight: FontWeight.w800,
                fontSize: 13
              ),
            ),
          ),
    
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontWeight: FontWeight.w800,
        fontSize: 16
      ),
      overflow: widget.bodyText.isEmpty ? TextOverflow.ellipsis : TextOverflow.fade,
      softWrap: true,
      maxLines: 2
    );
  }

  Widget _buildBodyText() {
    return Text(
      widget.bodyText,
      style: GoogleFonts.inter(
        color: ThemeColor.secondaryWhite,
        fontWeight: FontWeight.w800,
        fontSize: 12.7
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 4
    );
  }

  @override
  Widget build(BuildContext context) {

    final actionButtonsPadding = widget.bodyText.isEmpty ? 0.0 : 15.0;
    final actionButtonsHeightGap = widget.bodyText.isEmpty ? 0.0 : 15.0;

    return InkWellEffect(
      onPressed: () => _viewVentPostPage(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: ThemeColor.lightGrey,
            width: 0.8
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              Row(
                children: [

                  _buildCommunityAndCreatorHeader(),
        
                  const Spacer(),

                  _buildVentOptionsButton(),

                ],
              ),
        
              const SizedBox(height: 14),
        
              _buildTitle(),
        
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

                    const Spacer(),

                    _buildSaveButton()
                        
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