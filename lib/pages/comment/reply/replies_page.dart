import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/model/setup/replies_setup.dart';
import 'package:revent/pages/comment/reply/post_reply_page.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/post_id_getter.dart';
import 'package:revent/service/refresh_service.dart';
import 'package:revent/shared/provider/vent/vent_comment_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/bottom_input_bar.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/reply/replies_listview.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/vent_comment_previewer.dart';

class RepliesPage extends StatefulWidget {

  final String title;
  final String creator;

  final String commentedBy;
  final String comment;
  final String commentTimestamp;

  final bool isCommentLikedByCreator;

  final Uint8List pfpData;
  final Uint8List creatorPfpData;

  const RepliesPage({
    required this.title,
    required this.creator,
    required this.commentedBy,
    required this.comment,
    required this.commentTimestamp,
    required this.isCommentLikedByCreator,
    required this.pfpData,
    required this.creatorPfpData,
    super.key
  });

  @override
  State<RepliesPage> createState() => _RepliesPageState();

}

class _RepliesPageState extends State<RepliesPage> {

  late int commentId = 0;

  void _initializeReplies() async {

    try {
      
      final postId = await PostIdGetter(title: widget.title, creator: widget.creator).getPostId();

      commentId = await CommentIdGetter(postId: postId).getCommentId(
        username: widget.commentedBy, commentText: widget.comment
      );

      await RepliesSetup().setup(commentId: commentId);

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to load replies.');
    }

  }

  Widget _buildMainComment() {
    return Consumer<VentCommentProvider>(
      builder: (_, ventComment, __) {
        
        final commenterIndex = ventComment.ventComments.indexWhere(
          (comment) => comment.comment == widget.comment && comment.commentedBy == widget.commentedBy
        );
        
        final isCommentLiked = ventComment.ventComments[commenterIndex].isCommentLiked;

        final totalLikes = ventComment.ventComments[commenterIndex].totalLikes;
        final totalReplies = ventComment.ventComments[commenterIndex].totalReplies;

        return VentCommentPreviewer(
          title: widget.title, 
          creator: widget.creator, 
          commentedBy: widget.commentedBy, 
          comment: widget.comment, 
          commentTimestamp: widget.commentTimestamp, 
          totalLikes: totalLikes, 
          totalReplies: totalReplies,
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
      onRefresh: () async => await RefreshService().refreshReplies(commentId: commentId),
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
    
                RepliesListView(
                  creator: widget.creator, 
                  creatorPfpData: widget.creatorPfpData
                ),
    
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PostReplyPage(
              title: widget.title, 
              creator: widget.creator, 
              comment: widget.comment, 
              commentedBy: widget.commentedBy, 
              commenterPfp: widget.pfpData
              )
            )
          );
        }
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeReplies();
  }

  @override
  void dispose() {
    getIt.commentRepliesProvider.deleteReplies();
    super.dispose();
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