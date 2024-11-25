import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/pages/vent_post_page.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer_widgets.dart';

class HomeVentPreviewer extends StatefulWidget {

  final String title;
  final String bodyText;
  final String creator;
  final String postTimestamp;
  final int totalLikes;
  final int totalComments;
  final Uint8List pfpData;
  final bool isPostLiked;
  final bool isPostSaved;

  const HomeVentPreviewer({
    required this.title,
    required this.bodyText,
    required this.creator,
    required this.postTimestamp,
    required this.totalLikes,
    required this.totalComments, // TODO: Remove unused totalComments param
    required this.pfpData,
    required this.isPostLiked,
    required this.isPostSaved,
    super.key
  });

  @override
  State<HomeVentPreviewer> createState() => HomeVentPreviewerState();

}

class HomeVentPreviewerState extends State<HomeVentPreviewer> {

  void _viewVentPostPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => VentPostPage(
        title: widget.title, 
        bodyText: widget.bodyText, 
        postTimestamp: widget.postTimestamp,
        totalLikes: widget.totalLikes,
        creator: widget.creator, 
        pfpData: widget.pfpData,
      )),
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
      totalLikes: widget.totalLikes,
      totalComments: widget.totalComments,
      viewVentPostOnPressed: () => _viewVentPostPage(),
      deleteOnPressed: () async { // TODO: Remove this async
        CustomAlertDialog.alertDialogCustomOnPress(
          message: 'Delete this post?', 
          buttonMessage: 'Delete',
          onPressedEvent: () async {
            await CallVentActions(
              context: context, 
              title: widget.title, 
              creator: widget.creator
            ).deletePost();
          }
        );
      },
      reportOnPressed: () {},
      blockOnPressed: () {},
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
                  
              ventPreviewer.buildLikeButton(),
                  
              const SizedBox(width: 8),
                  
              ventPreviewer.buildCommentButton(),

              const Spacer(),

              ventPreviewer.buildSaveButton()
                  
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