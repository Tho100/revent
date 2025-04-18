import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/service/vent_actions_handler.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/vent/vent_post_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/service/query/search/search_data_getter.dart';
import 'package:revent/shared/widgets/vent_widgets/vent_previewer_widgets.dart';

class DefaultVentPreviewer extends StatefulWidget {

  final String title;
  final String bodyText;
  final String tags;
  final String postTimestamp;
  final String creator;

  final int totalLikes;
  final int totalComments;

  final Uint8List pfpData;

  final bool? isMyProfile;
  final bool? useV2ActionButtons;

  const DefaultVentPreviewer({
    required this.title,
    required this.bodyText,
    required this.tags,
    required this.postTimestamp,
    required this.creator,
    required this.totalLikes,
    required this.totalComments,
    required this.pfpData,
    this.isMyProfile = false,
    this.useV2ActionButtons = false,
    super.key
  });

  @override
  State<DefaultVentPreviewer> createState() => _DefaultVentPreviewerState();

}

class _DefaultVentPreviewerState extends State<DefaultVentPreviewer> with NavigationProviderService {

  late VentPreviewerWidgets ventPreviewer;
  late String ventBodyText;
  
  late int postId = 0;

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
      viewVentPostOnPressed: () => _viewVentPostPage(),
      removeSavedOnPressed: widget.isMyProfile!
        ? () async {
          await VentActionsHandler(
            title: widget.title, 
            creator: widget.creator, 
            context: context
          ).unsavePost();
        }
        : null,
      editOnPressed: () {
        Navigator.pop(context);
        NavigatePage.editVentPage(title: widget.title, body: widget.bodyText);
      },
      deleteOnPressed: () {
        CustomAlertDialog.alertDialogCustomOnPress(
          message: AlertMessages.deletePost, 
          buttonMessage: 'Delete',
          onPressedEvent: () async {
            await VentActionsHandler(
              title: widget.title, 
              creator: widget.creator, 
              context: context
            ).deletePost();
          }
        );
      },
      reportOnPressed: () {},
      blockOnPressed: () {
        Navigator.pop(context);
        CustomAlertDialog.alertDialogCustomOnPress(
          message: 'Block @${widget.creator}?', 
          buttonMessage: 'Block', 
          onPressedEvent: () async {
            await UserActions(username: widget.creator).blockUser().then(
              (_) => Navigator.pop(context)
            );
          }
        );
      },
    );
  }

  void _initializePostId() async {

    postId = await PostIdGetter(title: widget.title, creator: widget.creator).getPostId();
    
  }

  void _initializeBodyText() async {

    final customBodyTextPage = [AppRoute.searchResults.path];

    ventBodyText = customBodyTextPage.contains(navigationProvider.currentRoute)   
      ? await _getSearchResultsBodyText()
      : widget.bodyText;

  }

  Future<String> _getSearchResultsBodyText() async {

    return await SearchDataGetter(
      title: widget.title, 
      creator: widget.creator
    ).getBodyText();

  }

  void _viewVentPostPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VentPostPage(
        postId: postId,
        title: widget.title, 
        bodyText: ventBodyText, 
        tags: widget.tags,
        postTimestamp: widget.postTimestamp,
        totalLikes: widget.totalLikes,
        creator: widget.creator, 
        pfpData: widget.pfpData,
      )),
    );
  }

  Widget _v2ActionButtonsWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
      child: Row(
        children: [

          Icon(CupertinoIcons.heart_fill, color: ThemeColor.likedColor, size: 18.5),

          const SizedBox(width: 6),

          Text(
            widget.totalLikes.toString(),
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontWeight: FontWeight.w800,
              fontSize: 13.5,
            ),
            textAlign: TextAlign.start,
          ),

          const SizedBox(width: 18),

          Icon(CupertinoIcons.chat_bubble, color: ThemeColor.white, size: 18.5),
  
          const SizedBox(width: 6), 
  
          Text(
            widget.totalComments.toString(),
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
    
    final actionButtonsPadding = widget.bodyText.isEmpty ? 0.0 : 12.0;
    final actionButtonsHeightGap = widget.bodyText.isEmpty ? 0.0 : 12.0;

    return ventPreviewer.buildMainContainer(
      children: [

        Row(
          children: [

            ventPreviewer.buildHeaders(),
  
            const Spacer(),

            ventPreviewer.buildVentOptionsButton(),

          ],
        ),
  
        const SizedBox(height: 12),
  
        ventPreviewer.buildTitle(),

        if(widget.tags.isNotEmpty) ... [

          const SizedBox(height: 8),

          ventPreviewer.buildTags(),
          
          const SizedBox(height: 2),

        ],
  
        SizedBox(height: widget.bodyText.isEmpty ? 5 : 10),
  
        ventPreviewer.buildBodyText(),
  
        SizedBox(height: actionButtonsHeightGap),
  
        Padding(
          padding: EdgeInsets.only(top: actionButtonsPadding),
          child: widget.useV2ActionButtons! 
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
  void initState() {
    _initializePostId();
    _initializeBodyText();
    _initializeVentPreviewer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildVentPreview();
  }

} 