import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/pages/vent_post_page.dart';
import 'package:revent/widgets/buttons/actions_button.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer_widgets.dart';

class VentPreviewer extends StatefulWidget {

  final String title;
  final String bodyText;
  final String creator;
  final String postTimestamp;
  final int totalLikes;
  final int totalComments;
  final Uint8List pfpData;
  final bool isPostLiked;

  const VentPreviewer({
    required this.title,
    required this.bodyText,
    required this.creator,
    required this.postTimestamp,
    required this.totalLikes,
    required this.totalComments,
    required this.pfpData,
    required this.isPostLiked,
    super.key
  });

  @override
  State<VentPreviewer> createState() => VentPreviewerState();

}

class VentPreviewerState extends State<VentPreviewer> {

  void _viewVentPostPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => VentPostPage(
        title: widget.title, 
        bodyText: widget.bodyText, 
        postTimestamp: widget.postTimestamp,
        totalComments: widget.totalComments,
        totalLikes: widget.totalLikes,
        creator: widget.creator, 
        pfpData: widget.pfpData,
      )),
    );
  }

  Future<void> _saveVentOnPressed() async {

    await CallVentActions(
      context: context,
      title: widget.title,
      creator: widget.creator
    ).savePost();

  }

  Widget _buildLikeButton() {
    return ActionsButton().buildLikeButton(
      text: widget.totalLikes.toString(), 
      isLiked: widget.isPostLiked,
      onPressed: () async {
        await CallVentActions(
          context: context, 
          title: widget.title, 
          creator: widget.creator
        ).likePost();
      }
    );
  }

  Widget _buildCommentButton() {
    return ActionsButton().buildCommentsButton(
      text: widget.totalComments.toString(), 
      onPressed: () => _viewVentPostPage()
    );
  }

  Widget _buildSaveButton() {
    return ActionsButton().buildSaveButton(
      onPressed: () => {}
    );
  }

  Widget _buildVentPreview() {

    final ventPreviewer = VentPreviewerWidgets(
      context: navigatorKey.currentContext!,
      title: widget.title,
      bodyText: widget.bodyText,
      creator: widget.creator,
      pfpData: widget.pfpData,
      postTimestamp: widget.postTimestamp,
      viewVentPostOnPressed: () => _viewVentPostPage(),
      saveOnPressed: () async {
        await _saveVentOnPressed();
        if(context.mounted) {
          Navigator.pop(context);
        }
      },
    );

    final actionButtonsPadding = widget.bodyText.isEmpty ? 0.0 : 15.0;
    final actionButtonsHeightGap = widget.bodyText.isEmpty ? 0.0 : 15.0;

    return ventPreviewer.buildMainContainer(
      children: [

        Row(
          children: [

            ventPreviewer.buildHeaders(),
  
            const Spacer(),

            ventPreviewer.buildVentOptionsButton(),

          ],
        ),
  
        const SizedBox(height: 14),
  
        ventPreviewer.buildTitle(),
  
        const SizedBox(height: 12),
  
        ventPreviewer.buildBodyText(),
  
        SizedBox(height: actionButtonsHeightGap),
  
        Padding(
          padding: EdgeInsets.only(top: actionButtonsPadding),
          child: Row(
            children: [
                  
              _buildLikeButton(),
                  
              const SizedBox(width: 8),
                  
              _buildCommentButton(),

              const Spacer(),

              _buildSaveButton()
                  
            ],
          ),
        ),
  
      ]
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return _buildVentPreview();
  }
  
} 