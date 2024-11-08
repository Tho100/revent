import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/vent_comment_provider.dart';
import 'package:revent/widgets/vent_widgets/comments/vent_comment_previewer.dart';

class VentCommentsListView extends StatelessWidget {

  const VentCommentsListView({super.key});

  Widget _buildCommentPreview(VentComment ventComment) {
    return VentCommentPreviewer(
      commentedBy: ventComment.commentedBy,
      comment: ventComment.comment,
      pfpData: ventComment.pfpData
    );
  }

  Widget _buildOnEmpty() {
    return EmptyPage()
      .headerCustomMessage(header: 'No comment yet', subheader: 'Be the first to comment!');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VentCommentProvider>(
      builder: (_, commentData, __) {

        final isCommentsEmpty = commentData.ventComments.isEmpty;
        final commentsCount = isCommentsEmpty ? 1 : commentData.ventComments.length;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: commentsCount,
          itemBuilder: (_, index) {

            if(isCommentsEmpty) {
              return _buildOnEmpty();

            } else {
              final reversedIndex = commentData.ventComments.length - 1 - index;
              final ventComment = commentData.ventComments[reversedIndex];
              return _buildCommentPreview(ventComment);

            }

          }
        );
      },
    );
  }

}