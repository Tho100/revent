import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/model/setup/replies_setup.dart';
import 'package:revent/pages/comment/reply/post_reply_page.dart';
import 'package:revent/service/query/general/comment_id_getter.dart';
import 'package:revent/service/query/general/post_id_getter.dart';
import 'package:revent/service/refresh_service.dart';
import 'package:revent/shared/provider/vent/active_vent_provider.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/bottom_input_bar.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/styled_text_widget.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/reply/replies_listview.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/comment_previewer.dart';

class RepliesPage extends StatefulWidget {

  final String commentedBy;
  final String comment;
  final String commentTimestamp;

  final bool isCommentLikedByCreator;

  final Uint8List pfpData;

  const RepliesPage({
    required this.commentedBy,
    required this.comment,
    required this.commentTimestamp,
    required this.isCommentLikedByCreator,
    required this.pfpData,
    super.key
  });

  @override
  State<RepliesPage> createState() => _RepliesPageState();

}

class _RepliesPageState extends State<RepliesPage> {

  final activeVent = getIt.activeVentProvider.ventData;

  late int commentId = 0;

  void _initializeReplies() async {

    try {
      
      final postId = await PostIdGetter(
        title: activeVent.title, creator: activeVent.creator
      ).getPostId();

      commentId = await CommentIdGetter(postId: postId).getCommentId(
        username: widget.commentedBy, commentText: widget.comment
      );

      await RepliesSetup().setup(commentId: commentId);

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to load replies.');
    }

  }

  Widget _buildCreatorInfo() {
    return Row(
      children: [

        SizedBox(
          width: 35,
          height: 35,
          child: ProfilePictureWidget(
            customHeight: 35,
            customWidth: 35,
            customEmptyPfpSize: 20,
            pfpData: getIt.activeVentProvider.ventData.creatorPfp,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          activeVent.creator,
          style: GoogleFonts.inter(
            color: ThemeColor.secondaryWhite,
            fontWeight: FontWeight.w800,
            fontSize: 14.5
          ),
        ),

      ],
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
    
        Positioned(
          left: 35 / 2,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1,
            color: ThemeColor.lightGrey,
          ),
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(width: 40),
          
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 10),

                  SelectableText(
                    activeVent.title,
                    style: GoogleFonts.inter(
                      color: ThemeColor.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 21,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Consumer<ActiveVentProvider>(
                    builder: (_, data, __) {
                      return StyledTextWidget(
                        text: data.ventData.body,
                        isSelectable: true,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),

                ],
              ),
            ),
          ],
        ),

      ],
    );
  }

  Widget _buildMainComment() {
    return Consumer<CommentsProvider>(
      builder: (_, ventComment, __) {
        
        final commenterIndex = ventComment.ventComments.indexWhere(
          (comment) => comment.comment == widget.comment && comment.commentedBy == widget.commentedBy
        );
        
        final isCommentLiked = ventComment.ventComments[commenterIndex].isCommentLiked;

        final totalLikes = ventComment.ventComments[commenterIndex].totalLikes;
        final totalReplies = ventComment.ventComments[commenterIndex].totalReplies;

        return CommentPreviewer(
          commentedBy: widget.commentedBy, 
          comment: widget.comment, 
          commentTimestamp: widget.commentTimestamp, 
          totalLikes: totalLikes, 
          totalReplies: totalReplies,
          isCommentLiked: isCommentLiked, 
          isCommentLikedByCreator: widget.isCommentLikedByCreator, 
          pfpData: widget.pfpData, 
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

                _buildCreatorInfo(),

                _buildHeader(),

                _buildMainComment(),
    
                RepliesListView(
                  comment: widget.comment,
                  commentedBy: widget.commentedBy
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