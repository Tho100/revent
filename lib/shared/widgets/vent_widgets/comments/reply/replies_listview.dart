import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/vent/replies_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/reply/reply_previewer.dart';

class RepliesListView extends StatelessWidget {

  final String comment;
  final String commentedBy;

  const RepliesListView({
    required this.comment,
    required this.commentedBy,
    super.key
  });

  Widget _buildCommentPreview(ReplyData replyData) {
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
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(color: ThemeColor.lightGrey, height: 1),
            )
          ),

          EmptyPage().customMessage(message: 'No replies yet'),

          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(color: ThemeColor.lightGrey, height: 1),
            )
          ),

        ],
      ),
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
        final reversedIndex = repliesData.replies.length - 1 - index;
        final ventComment = repliesData.replies[reversedIndex];
        return _buildCommentPreview(ventComment);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RepliesProvider>(
      builder: (_, repliesData, __) {

        final isCommentsEmpty = repliesData.replies.isEmpty;
        final repliesCount = repliesData.replies.length;

        return isCommentsEmpty 
          ? _buildOnEmpty()
          : _buildListView(repliesData: repliesData, repliesCount: repliesCount);

      },
    );
  }

}