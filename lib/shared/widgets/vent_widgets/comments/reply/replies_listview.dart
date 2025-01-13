import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/vent/comment_replies_provider.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/reply/reply_previewer.dart';

// TODO: Update to RepliesListView
class RepliesListView extends StatelessWidget {

  final String title;
  final String creator;
  final Uint8List creatorPfpData;

  const RepliesListView({
    required this.title,
    required this.creator,
    required this.creatorPfpData,
    super.key
  });

  Widget _buildCommentPreview(CommentRepliesData replyData) {
    return ReplyPreviewer(
      title: title,
      creator: creator,
      commentedBy: replyData.repliedBy,
      comment: replyData.reply,
      commentTimestamp: replyData.replyTimestamp,
      totalLikes: replyData.totalLikes,
      isCommentLiked: replyData.isReplyLiked,
      isCommentLikedByCreator: replyData.isReplyLikedByCreator,
      pfpData: replyData.pfpData,
      creatorPfpData: creatorPfpData
    );
  }

  Widget _buildOnEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: EmptyPage().customMessage(message: 'No replies yet.')
    );
  }

  Widget _buildListView({
    required CommentRepliesProvider repliesData,
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
    return Consumer<CommentRepliesProvider>(
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