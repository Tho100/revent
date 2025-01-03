import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/shared/provider/vent/vent_comment_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/bottom_input_bar.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/vent_comment_previewer.dart';

class ReplyCommentPage extends StatefulWidget {

  final String title;
  final String creator;

  final String commentedBy;
  final String comment;
  final String commentTimestamp;

  final int totalReplies;

  final bool isCommentLikedByCreator;

  final Uint8List pfpData;
  final Uint8List creatorPfpData;

  const ReplyCommentPage({
    required this.title,
    required this.creator,
    required this.commentedBy,
    required this.comment,
    required this.commentTimestamp,
    required this.totalReplies,
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
    return Consumer<VentCommentProvider>(
      builder: (_, ventComment, __) {
        
        final commenterIndex = ventComment.ventComments.indexWhere(
          (comment) => comment.comment == widget.comment && comment.commentedBy == widget.commentedBy
        );
        final isCommentLiked = ventComment.ventComments[commenterIndex].isCommentLiked;
        final totalLikes = ventComment.ventComments[commenterIndex].totalLikes;

        return VentCommentPreviewer(
          title: widget.title, 
          creator: widget.creator, 
          commentedBy: widget.commentedBy, 
          comment: widget.comment, 
          commentTimestamp: widget.commentTimestamp, 
          totalLikes: totalLikes, 
          isCommentLiked: isCommentLiked, 
          isCommentLikedByCreator: widget.isCommentLikedByCreator, 
          pfpData: widget.pfpData, 
          creatorPfpData: widget.creatorPfpData
        );
      },
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
      child: BottomInputBar(
        hintText: 'Reply to @${widget.commentedBy}', 
        onPressed: () {}
      )
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
      bottomNavigationBar: _buildAddReply()
    );
  }

}