import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/reply/reply_previewer.dart';

class RepliesListView extends StatelessWidget {

  final String comment;
  final String commentedBy;

  const RepliesListView({
    required this.comment,
    required this.commentedBy,
    super.key
  });

  Widget _buildCommentPreview(CommentRepliesData replyData) {
    return ReplyPreviewer(
      comment: comment,
      commentedBy: commentedBy,
      repliedBy: replyData.repliedBy,
      reply: replyData.reply,
      replyTimestamp: replyData.replyTimestamp,
      totalLikes: replyData.totalLikes,
      isReplyLiked: replyData.isReplyLiked,
      isReplyLikedByCreator: replyData.isReplyLikedByCreator,
      pfpData: replyData.pfpData,
    );
  }

  Widget _buildOnEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: EmptyPage().customMessage(message: 'No replies yet.')
    );
  }

  Widget _buildListView({
    required RepliesProvider repliesData,
    required int repliesCount,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: repliesCount,
      itemBuilder: (_, index) {
        final reversedIndex = repliesData.commentReplies.length - 1 - index;
        final ventComment = repliesData.commentReplies[reversedIndex];
        return _buildCommentPreview(ventComment);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RepliesProvider>(
      builder: (_, repliesData, __) {

        final isCommentsEmpty = repliesData.commentReplies.isEmpty;
        final repliesCount = repliesData.commentReplies.length;

        return isCommentsEmpty 
          ? _buildOnEmpty()
          : _buildListView(repliesData: repliesData, repliesCount: repliesCount);

      },
    );
  }

}