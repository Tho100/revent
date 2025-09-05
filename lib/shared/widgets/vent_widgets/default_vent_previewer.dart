import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/tabs_type.dart';
import 'package:revent/helper/navigator_extension.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/post_id_getter.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/service/vent_actions_handler.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/vent/vent_post_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/report_post_bottomsheet.dart';
import 'package:revent/shared/widgets/nsfw_widget.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/service/query/vent/vent_data_getter.dart';
import 'package:revent/shared/widgets/vent_widgets/vent_previewer_widgets.dart';

class DefaultVentPreviewer extends StatefulWidget {

  final String title;
  final String bodyText;
  final String tags;
  final String postTimestamp;
  final String creator;

  final int totalLikes;
  final int totalComments;
  final bool isNsfw;

  final Uint8List pfpData;

  final bool isPinned;
  final bool isMyProfile;
  final bool disableActionButtons;

  const DefaultVentPreviewer({
    required this.title,
    required this.bodyText,
    required this.tags,
    required this.postTimestamp,
    required this.creator,
    required this.totalLikes,
    required this.totalComments,
    required this.isNsfw,
    required this.pfpData,
    this.isPinned = false,
    this.isMyProfile = false,
    this.disableActionButtons = false,
    super.key
  });

  @override
  State<DefaultVentPreviewer> createState() => _DefaultVentPreviewerState();

}

class _DefaultVentPreviewerState extends State<DefaultVentPreviewer> with 
  NavigationProviderService, 
  VentProviderService {

  late VentPreviewerWidgets ventPreviewer;
  late VentActionsHandler actionsHandler;

  int postId = 0;
  
  void _initializeVentPreviewer() {
    ventPreviewer = VentPreviewerWidgets(
      context: context,
      title: widget.title,
      bodyText: widget.bodyText,
      creator: widget.creator,
      pfpData: widget.pfpData,
      postTimestamp: widget.postTimestamp,
      tags: widget.tags,
      totalLikes: widget.totalLikes,
      totalComments: widget.totalComments,
      unSaveOnPressed: widget.isMyProfile && navigationProvider.profileTab == ProfileTabs.savedPosts
        ? actionsHandler.unsavePost
        : null, 
      pinOnPressed: widget.isMyProfile && navigationProvider.profileTab == ProfileTabs.posts && !widget.isPinned
        ? actionsHandler.pinPost
        : null,
      unPinOnPressed: widget.isMyProfile && navigationProvider.profileTab == ProfileTabs.posts && widget.isPinned
        ? actionsHandler.unpinPost
        : null,
      editOnPressed: _onEditPressed,
      deleteOnPressed: _onDeletePressed,
      reportOnPressed: _onReportPressed,
      blockOnPressed: _onBlockPressed,
      navigateVentPostPageOnPressed: _navigateToVentPostPage
    );
  }

  void _onEditPressed() {

    context.popAndRunAsync(() async {

        final isInSearchResults = navigationProvider.currentRoute == AppRoute.searchResults;

        final body = isInSearchResults
          ? await _getVentBodyText() : widget.bodyText;

        NavigatePage.editVentPage(title: widget.title, body: body);

    });

  }

  void _onDeletePressed() {
    context.popAndRun(() {
      CustomAlertDialog.alertDialogCustomOnPress(
        message: AlertMessages.deletePost, 
        buttonMessage: 'Delete',
        onPressedEvent: () async => await actionsHandler.deletePost()
      );
    });
  }

  void _onReportPressed() {
    context.popAndRun(
      () => ReportPostBottomsheet().buildBottomsheet(context: context)
    );
  }

  void _onBlockPressed() {
    context.popAndRun(() {
      CustomAlertDialog.alertDialogCustomOnPress(
        message: 'Block @${widget.creator}?', 
        buttonMessage: 'Block', 
        onPressedEvent: () async {
          await UserActions(username: widget.creator).toggleBlockUser().then(
            (_) => Navigator.pop(context)
          );
        }
      );
    });
  }

  void _initializeVentActionsHandler() {
    actionsHandler = VentActionsHandler(              
      title: widget.title, 
      creator: widget.creator, 
      context: context
    );
  }

  Future<void> _initializePostId() async {
    postId = await PostIdGetter(
      title: widget.title, 
      creator: widget.creator
    ).getPostId();
  }

  Future<String> _initializeBodyText() async {

    final hasActiveBodyText = 
      activeVentProvider.ventData.body.isNotEmpty && 
      activeVentProvider.ventData.postId == postId;

    final getBodyTextOnCondition = 
      navigationProvider.currentRoute == AppRoute.searchResults ||
      widget.isNsfw || (widget.bodyText.length >= 125 && !hasActiveBodyText);

    return getBodyTextOnCondition
      ? await _getVentBodyText() : (hasActiveBodyText ? activeVentProvider.ventData.body : widget.bodyText);

  }

  Future<String> _getVentBodyText() async {
    return await VentDataGetter(postId: postId).getBodyText();
  }

  void _navigateToVentPostPage() async {

    await _initializeBodyText().then((bodyText) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VentPostPage(
            postId: postId,
            title: widget.title, 
            bodyText: bodyText, 
            tags: widget.tags,
            postTimestamp: widget.postTimestamp,
            isNsfw: widget.isNsfw,
            totalLikes: widget.totalLikes,
            creator: widget.creator, 
            pfpData: widget.pfpData,
          )
        ),
      );
    });

  }

  Widget _disabledActionButtonsWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
      child: Row(
        children: [

          Icon(CupertinoIcons.heart_fill, color: ThemeColor.likedColor, size: 18.5),

          const SizedBox(width: 6),

          Text(
            widget.totalLikes.toString(),
            style: GoogleFonts.inter(
              color: ThemeColor.contentPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
            textAlign: TextAlign.start,
          ),

          const SizedBox(width: 18),

          Icon(CupertinoIcons.chat_bubble, color: ThemeColor.contentPrimary, size: 18.5),
  
          const SizedBox(width: 6), 
  
          Text(
            widget.totalComments.toString(),
            style: GoogleFonts.inter(
              color: ThemeColor.contentPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildVentPreview() {
    
    final actionButtonsPadding = widget.bodyText.isEmpty ? 0.0 : 12.0;
    final actionButtonsHeightGap = widget.bodyText.isEmpty ? 0.0 : 12.0;

    return ventPreviewer.buildMainContainer(
      children: [

        if (widget.isPinned) ... [

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
          
                Icon(CupertinoIcons.pin, color: ThemeColor.contentThird, size: 16),
          
                const SizedBox(width: 4),

                Text('Pinned Post',
                  style: GoogleFonts.inter(
                    color: ThemeColor.contentThird,
                    fontWeight: FontWeight.w800,
                    fontSize: 13
                  ),
                )
          
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Divider(color: ThemeColor.divider),
          ),

        ],

        Row(
          children: [

            ventPreviewer.buildHeaders(),
  
            const Spacer(),

            ventPreviewer.buildVentOptionsButton(),

          ],
        ),
  
        const SizedBox(height: 12),
  
        if (widget.isNsfw) 
        const NsfwWidget(),

        ventPreviewer.buildTitle(),

        if (widget.tags.isNotEmpty) ... [

          const SizedBox(height: 8),

          ventPreviewer.buildTags(),
          
          const SizedBox(height: 2),

        ],
  
        SizedBox(height: widget.bodyText.isEmpty ? 5 : 10),
  
        ventPreviewer.buildBodyText(),
  
        SizedBox(height: actionButtonsHeightGap),
  
        Padding(
          padding: EdgeInsets.only(top: actionButtonsPadding),
          child: widget.disableActionButtons
            ? _disabledActionButtonsWidget()
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
  void initState() {
    super.initState();
    _initializeVentActionsHandler();
    _initializePostId().then(
      (_) => _initializeBodyText()
    );
    _initializeVentPreviewer();
  }

  @override
  Widget build(BuildContext context) {
    return _buildVentPreview();
  }

} 