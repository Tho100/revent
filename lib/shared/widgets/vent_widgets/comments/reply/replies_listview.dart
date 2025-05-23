import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  Widget _buildReplyPreviewer(ReplyData replyData) {
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

  Widget _buildOnNoReplies() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 14.0),
              child: Divider(color: ThemeColor.divider),
            )
          ),

          Text(
            'No replies yet',
            style: GoogleFonts.inter(
              color: ThemeColor.contentThird,
              fontWeight: FontWeight.w800,
              fontSize: 13
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0, right: 4.0),
              child: Divider(color: ThemeColor.divider),
            )
          ),

        ],
      ),
    );
  }

  Widget _buildListView(List<ReplyData> replies) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: replies.length,
      itemBuilder: (_, index) {
        final reversedIndex = replies.length - 1 - index;
        final reply = replies[reversedIndex];
        return _buildReplyPreviewer(reply);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RepliesProvider>(
      builder: (_, repliesData, __) {

        final replies = repliesData.replies;

        return replies.isEmpty 
          ? _buildOnNoReplies()
          : _buildListView(replies);

      },
    );
  }

}