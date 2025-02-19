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

          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 4.0, right: 14.0),
              child: Divider(color: ThemeColor.lightGrey),
            )
          ),

          Text(
            'No replies yet',
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 13
            ),
          ),

          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 14.0, right: 4.0),
              child: Divider(color: ThemeColor.lightGrey),
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
        final reply = repliesData.replies[reversedIndex];
        return _buildReplyPreviewer(reply);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RepliesProvider>(
      builder: (_, repliesData, __) {

        final isRepliesEmpty = repliesData.replies.isEmpty;
        final repliesCount = repliesData.replies.length;

        return isRepliesEmpty 
          ? _buildOnNoReplies()
          : _buildListView(repliesData: repliesData, repliesCount: repliesCount);

      },
    );
  }

}