import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/app_keys.dart';
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

  Widget _buildCommentPreview(CommentsData commentData) {

    final commentedBy = commentData.commentedBy;
    final comment = commentData.comment;
    final commentTimestamp = commentData.commentTimestamp;
    final isCommentLikedByCreator = commentData.isCommentLikedByCreator;
    final pfpData = commentData.pfpData;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          navigatorKey.currentContext!,
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
          totalLikes: commentData.totalLikes,
          totalReplies: commentData.totalReplies,
          isCommentLiked: commentData.isCommentLiked,
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
          ? 'Be the first to comment!' : 'The author has disabled commenting \nfor this post.'
      ),
    );
  }

  Widget _buildListView(List<CommentsData> comments) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (_, index) {
        final reversedIndex = comments.length - 1 - index;
        final comment = comments[reversedIndex];
        return _buildCommentPreview(comment);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentsProvider>(
      builder: (_, commentsData, __) {

        final comments = commentsData.comments;

        return comments.isEmpty 
          ? _buildOnEmpty()
          : _buildListView(comments);

      },
    );
  }

}