import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/comment/reply/replies_page.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/vent/comments_provider.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/comment_previewer.dart';

class CommentsListView extends StatelessWidget {
  
  final bool isCommentEnabled;

  const CommentsListView({
    required this.isCommentEnabled,
    super.key
  });

  Widget _buildCommentPreview(CommentsData comments, BuildContext context) {

    final commentedBy = comments.commentedBy;
    final comment = comments.comment;
    final commentTimestamp = comments.commentTimestamp;
    final totalLikes = comments.totalLikes;
    final totalReplies = comments.totalReplies;
    final isCommentLiked = comments.isCommentLiked;
    final isCommentLikedByCreator = comments.isCommentLikedByCreator;
    final pfpData = comments.pfpData;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RepliesPage(
            commentedBy: commentedBy, 
            comment: comment, 
            commentTimestamp: commentTimestamp, 
            isCommentLikedByCreator: isCommentLikedByCreator, 
            pfpData: pfpData, 
          ))
        );
      },
      child: Container(
        color: Colors.transparent,
        child: CommentPreviewer(
          isOnRepliesPage: false,
          commentedBy: commentedBy,
          comment: comment,
          commentTimestamp: commentTimestamp,
          totalLikes: totalLikes,
          totalReplies: totalReplies,
          isCommentLiked: isCommentLiked,
          isCommentLikedByCreator: isCommentLikedByCreator,
          pfpData: pfpData,
        ),
      ),
    );
  }

  Widget _buildOnEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: EmptyPage().headerCustomMessage(
        header: isCommentEnabled 
          ? 'No comment yet' : 'Commenting disabled', 
        subheader: isCommentEnabled 
          ? 'Be the first to comment!' : 'The author has disabled commenting for this post.'
      ),
    );
  }

  Widget _buildListView({
    required CommentsProvider commentData,
    required int commentsCount,
    required BuildContext context
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commentsCount,
      itemBuilder: (_, index) {
        final reversedIndex = commentData.comments.length - 1 - index;
        final ventComment = commentData.comments[reversedIndex];
        return _buildCommentPreview(ventComment, context);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentsProvider>(
      builder: (_, commentData, __) {

        final isCommentsEmpty = commentData.comments.isEmpty;
        final commentsCount = commentData.comments.length;

        return isCommentsEmpty 
          ? _buildOnEmpty()
          : _buildListView(commentData: commentData, commentsCount: commentsCount, context: context);
      },
    );
  }

}