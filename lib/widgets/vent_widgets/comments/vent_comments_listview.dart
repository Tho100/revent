import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/provider/vent_comment_provider.dart';
import 'package:revent/widgets/vent_widgets/comments/vent_comment_previewer.dart';

class VentCommentsListView extends StatelessWidget {

  const VentCommentsListView({super.key});

  Widget _buildCommentPreview(VentComment ventComment) {
    return VentCommentPreviewer(
      commentedBy: ventComment.commentedBy,
      comment: ventComment.comment,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VentCommentProvider>(
      builder: (_, commentData, __) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: commentData.ventComments.length,
          itemBuilder: (_, index) {
            final reversedIndex = commentData.ventComments.length - 1 - index;
            final ventComment = commentData.ventComments[reversedIndex];
            return _buildCommentPreview(ventComment);
          }
        );
      },
    );
  }

}