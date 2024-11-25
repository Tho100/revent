import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/call_vent_actions.dart';
import 'package:revent/helper/current_provider.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/bottomsheet_widgets/vent_post_actions.dart';
import 'package:revent/widgets/buttons/actions_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

class VentPreviewerWidgets {

  final BuildContext context;

  final String? title;
  final String? bodyText;
  final String? creator;
  final String? postTimestamp;
  final int? totalLikes;
  final int? totalComments;
  final Uint8List? pfpData;

  final VoidCallback? viewVentPostOnPressed;
  final VoidCallback? copyOnPressed;
  final VoidCallback? reportOnPressed;
  final VoidCallback? blockOnPressed;
  final VoidCallback? removeSavedOnPressed;
  final VoidCallback? deleteOnPressed;

  const VentPreviewerWidgets({
    required this.context,
    this.title,
    this.bodyText,
    this.creator,
    this.postTimestamp,
    this.totalLikes,
    this.totalComments,
    this.pfpData,
    this.viewVentPostOnPressed,
    this.reportOnPressed,
    this.blockOnPressed,
    this.removeSavedOnPressed,
    this.deleteOnPressed,
    this.copyOnPressed
  });

  Widget buildLikeButton() {

    final currentProvider = CurrentProvider(
      title: title!, 
      creator: creator!
    ).getProvider();

    final ventIndex = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    return ActionsButton().buildLikeButton(
      text: ventData.vents[ventIndex].totalLikes.toString(), 
      isLiked: ventData.vents[ventIndex].isPostLiked,
      onPressed: () async {
        await CallVentActions(
          context: context, 
          title: title!, 
          creator: creator!
        ).likePost();
      }
    );
  }

  Widget buildCommentButton() {
    return ActionsButton().buildCommentsButton(
      text: totalComments.toString(), 
      onPressed: viewVentPostOnPressed!
    );
  }

  Widget buildSaveButton() {

    final currentProvider = CurrentProvider(
      title: title!, 
      creator: creator!
    ).getProvider();

    final ventIndex = currentProvider['vent_index'];
    final ventData = currentProvider['vent_data'];

    return ActionsButton().buildSaveButton(
      isSaved: ventData.vents[ventIndex].isPostSaved,
      onPressed: () async {
        await CallVentActions(
          context: context, 
          title: title!, 
          creator: creator!
        ).savePost();
      }
    );

  }

  Widget buildVentOptionsButton({Widget? customIconWidget}) {
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: SizedBox(
        width: 25,
        height: 25,
        child: IconButton(
          onPressed: () {

            if (copyOnPressed == null && removeSavedOnPressed == null && 
              deleteOnPressed == null && reportOnPressed == null && blockOnPressed == null) {
              return;
            }

            BottomsheetVentPostActions().buildBottomsheet(
              context: context, 
              title: title!,
              creator: creator!,
              copyOnPressed: copyOnPressed,
              removeSavedPostOnPressed: removeSavedOnPressed,
              reportOnPressed: reportOnPressed,
              blockOnPressed: blockOnPressed,
              deleteOnPressed: deleteOnPressed
            );

          },
          icon: customIconWidget ?? Transform.translate(
            offset: const Offset(0, -10),
            child: const Icon(CupertinoIcons.ellipsis, color: ThemeColor.thirdWhite, size: 18)
          )
        ),
      ),
    );
  }

  Widget buildHeaders() {
    return InkWellEffect(
      onPressed: () => NavigatePage.userProfilePage(username: creator!, pfpData: pfpData!),
      child: Row(
        children: [
    
          ProfilePictureWidget(
            customWidth: 30,
            customHeight: 30,
            pfpData: pfpData,
          ),
    
          const SizedBox(width: 8),
    
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              '@$creator',
              style: GoogleFonts.inter(
                color: ThemeColor.secondaryWhite,
                fontWeight: FontWeight.w800,
                fontSize: 14
              ),
            ),
          ),
    
          const SizedBox(width: 8),
    
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              postTimestamp!,
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontWeight: FontWeight.w800,
                fontSize: 13
              ),
            ),
          ),
    
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      title!,
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontWeight: FontWeight.w800,
        fontSize: 16
      ),
      overflow: bodyText!.isEmpty ? TextOverflow.ellipsis : TextOverflow.fade,
      softWrap: true,
      maxLines: 2
    );
  }

  Widget buildBodyText() {
    return Text(
      bodyText!,
      style: GoogleFonts.inter(
        color: ThemeColor.secondaryWhite,
        fontWeight: FontWeight.w800,
        fontSize: 12.7
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 4
    );
  }

  Widget buildMainContainer({required List<Widget> children}) {
    return InkWellEffect(
      onPressed: viewVentPostOnPressed!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: ThemeColor.lightGrey,
            width: 0.8
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
          )
        )
      )
    );
  }

} 