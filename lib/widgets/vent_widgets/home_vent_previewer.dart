import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/vent/vent_post_page.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer_widgets.dart';

class HomeVentPreviewer extends StatelessWidget {

  final String title;
  final String bodyText;
  final String creator;

  final String postTimestamp;
  final int totalLikes;
  final int totalComments;

  final Uint8List pfpData;

  const HomeVentPreviewer({
    required this.title,
    required this.bodyText,
    required this.creator,
    required this.postTimestamp,
    required this.totalLikes,
    required this.totalComments,
    required this.pfpData,
    super.key
  });

  void _viewVentPostPage() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => VentPostPage(
        title: title, 
        bodyText: bodyText, 
        postTimestamp: postTimestamp,
        totalLikes: totalLikes,
        creator: creator, 
        pfpData: pfpData,
      )),
    );
  }

  Widget _buildVentPreview() {

    final ventPreviewer = VentPreviewerWidgets(
      context: navigatorKey.currentContext!,
      title: title,
      bodyText: bodyText,
      creator: creator,
      pfpData: pfpData,
      postTimestamp: postTimestamp,
      totalLikes: totalLikes,
      totalComments: totalComments,
      viewVentPostOnPressed: () => _viewVentPostPage(),
      editOnPressed: () {
        Navigator.pop(navigatorKey.currentContext!);
        NavigatePage.editVentPage(title: title, body: bodyText);
      },
      deleteOnPressed: () {
        CustomAlertDialog.alertDialogCustomOnPress(
          message: 'Delete this post?', 
          buttonMessage: 'Delete',
          onPressedEvent: () async {
            await CallVentActions(
              context: navigatorKey.currentContext!, 
              title: title, 
              creator: creator
            ).deletePost();
          }
        );
      },
      reportOnPressed: () {},
      blockOnPressed: () {},
    );

    final actionButtonsPadding = bodyText.isEmpty ? 0.0 : 15.0;
    final actionButtonsHeightGap = bodyText.isEmpty ? 0.0 : 15.0;

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