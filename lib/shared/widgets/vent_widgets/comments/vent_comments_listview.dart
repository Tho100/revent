import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/vent/vent_comment_provider.dart';
import 'package:revent/shared/widgets/vent_widgets/comments/vent_comment_previewer.dart';

class VentCommentsListView extends StatelessWidget {

  final String title;
  final String creator;
  final Uint8List creatorPfpData;
  final bool isCommentEnabled;

  const VentCommentsListView({
    required this.title,
    required this.creator,
    required this.creatorPfpData,
    required this.isCommentEnabled,
    super.key
  });

  Widget _buildCommentPreview(VentCommentData ventComment) {
    return VentCommentPreviewer(
      title: title,
      creator: creator,
      commentedBy: ventComment.commentedBy,
      comment: ventComment.comment,
      commentTimestamp: ventComment.commentTimestamp,
      totalLikes: ventComment.totalLikes,
      isCommentLiked: ventComment.isCommentLiked,
      isCommentLikedByCreator: ventComment.isCommentLikedByCreator,
      pfpData: ventComment.pfpData,
      creatorPfpData: creatorPfpData
    );
  }

  Widget _buildOnEmpty() {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: EmptyPage().headerCustomMessage(
        header: isCommentEnabled 
          ? 'No comment yet' : 'Comment disabled', 
        subheader: isCommentEnabled 
          ? 'Be the first to comment!' : 'The author has disabled comment for this post.'
      ),
    );
  }

  Widget _buildListView({
    required VentCommentProvider commentData,
    required int commentsCount,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commentsCount,
      itemBuilder: (_, index) {
        final reversedIndex = commentData.ventComments.length - 1 - index;
        final ventComment = commentData.ventComments[reversedIndex];
        return _buildCommentPreview(ventComment);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VentCommentProvider>(
      builder: (_, commentData, __) {

        final isCommentsEmpty = commentData.ventComments.isEmpty;
        final commentsCount = commentData.ventComments.length;

        return isCommentsEmpty 
          ? _buildOnEmpty()
          : _buildListView(commentData: commentData, commentsCount: commentsCount);
      },
    );
  }

}