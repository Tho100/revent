import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/helper/app_route.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/vent/vent_post_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/vent_query/search_data_getter.dart';
import 'package:revent/widgets/vent_widgets/vent_previewer_widgets.dart';

class DefaultVentPreviewer extends StatelessWidget {

  final String title;
  final String bodyText;
  final String creator;

  final String postTimestamp;
  final int totalLikes;
  final int totalComments;

  final Uint8List pfpData;

  final bool? isMyProfile;
  final bool? useV2ActionButtons;

  const DefaultVentPreviewer({
    required this.title,
    required this.bodyText,
    required this.creator,
    required this.postTimestamp,
    required this.totalLikes,
    required this.totalComments,
    required this.pfpData,
    this.isMyProfile = false,
    this.useV2ActionButtons = false,
    super.key
  });

  Future<String> _getSearchResultsBodyText() async {

    return await SearchDataGetter(
      title: title, 
      creator: creator
    ).getBodyText();

  }

  Future<String> _initializeBodyText() async {

    final navigation = GetIt.instance<NavigationProvider>();

    final customBodyTextPage = [AppRoute.searchResults];

    if(customBodyTextPage.contains(navigation.currentRoute)) {
      return await _getSearchResultsBodyText();

    } else {
      return bodyText;

    }

  }

  void _viewVentPostPage() async {
    
    final ventBodyText = await _initializeBodyText();

    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => VentPostPage(
        title: title, 
        bodyText: ventBodyText, 
        postTimestamp: postTimestamp,
        totalLikes: totalLikes,
        creator: creator, 
        pfpData: pfpData,
      )),
    );

  }

  Widget _v2ActionButtonsWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
      child: Row(
        children: [

          const Icon(CupertinoIcons.heart_fill, color: ThemeColor.likedColor, size: 18.5),

          const SizedBox(width: 6),

          Text(
            totalLikes.toString(),
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
            textAlign: TextAlign.start,
          ),

          const SizedBox(width: 18),

          const Icon(CupertinoIcons.chat_bubble, color: ThemeColor.white, size: 18.5),
  
          const SizedBox(width: 6), 
  
          Text(
            totalComments.toString(),
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          ),

        ],
      ),
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
      removeSavedOnPressed: isMyProfile!
        ? () async {
        await CallVentActions(
          context: navigatorKey.currentContext!, 
          title: title, 
          creator: creator
        ).removeSavedPost();
      } : null,
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
          child: useV2ActionButtons! 
            ? _v2ActionButtonsWidget()
            : Row(
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