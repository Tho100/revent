import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/vent_comment_previewer.dart';

class ReplyCommentPage extends StatefulWidget {

  final String title;
  final String creator;

  final String commentedBy;
  final String comment;
  final String commentTimestamp;

  final int totalLikes;
  final int totalReplies;

  final bool isCommentLiked;
  final bool isCommentLikedByCreator;

  final Uint8List pfpData;
  final Uint8List creatorPfpData;

  const ReplyCommentPage({
    required this.title,
    required this.creator,
    required this.commentedBy,
    required this.comment,
    required this.commentTimestamp,
    required this.totalLikes,
    required this.totalReplies,
    required this.isCommentLiked,
    required this.isCommentLikedByCreator,
    required this.pfpData,
    required this.creatorPfpData,
    super.key
  });

  @override
  State<ReplyCommentPage> createState() => _ReplyCommentPageState();

}

class _ReplyCommentPageState extends State<ReplyCommentPage> {

  Widget _buildMainComment() {
    return VentCommentPreviewer(
      title: widget.title, 
      creator: widget.creator, 
      commentedBy: widget.commentedBy, 
      comment: widget.comment, 
      commentTimestamp: widget.commentTimestamp, 
      totalLikes: widget.totalLikes, 
      isCommentLiked: widget.isCommentLiked, 
      isCommentLikedByCreator: widget.isCommentLikedByCreator, 
      pfpData: widget.pfpData, 
      creatorPfpData: widget.creatorPfpData
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(      
      color: ThemeColor.black,
      onRefresh: () async {},
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 18.0, right: 18.0),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildMainComment(),

                Transform.translate(
                  offset: const Offset(0, -10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Divider(color: ThemeColor.lightGrey),
                  ),
                ),
                
                const SizedBox(height: 20),
    
                // replies listview
    
                const SizedBox(height: 10),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddReply() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 18.0),
      child: Row(
        children: [
          Expanded(
            child: InkWellEffect(
              onPressed: () {},
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ThemeColor.thirdWhite)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
          
                        ProfilePictureWidget(
                          customHeight: 26,
                          customWidth: 26,
                          pfpData: getIt.profileProvider.profile.profilePicture,
                        ),
          
                        const SizedBox(width: 10),
          
                        Text(
                          'Reply to @${widget.commentedBy}',
                          style: GoogleFonts.inter(
                            color: ThemeColor.thirdWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: 14
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                )
              )
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: 'Reply'
      ).buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildAddReply(),
    );
  }

}