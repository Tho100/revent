import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/service/vent_actions_handler.dart';
import 'package:revent/service/current_provider_service.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/vents/vent_post_actions.dart';
import 'package:revent/shared/widgets/buttons/actions_button.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/text/styled_text_widget.dart';

class VentPreviewerWidgets {

  final BuildContext context;

  final String? title;
  final String? bodyText;
  final String? tags;
  final String? postTimestamp;
  final bool? isNsfw;
  final int? totalLikes;
  final int? totalComments;
  final String? creator;
  final Uint8List? pfpData;

  final VoidCallback? navigateVentPostPageOnPressed;
  final VoidCallback? editOnPressed;
  final VoidCallback? copyOnPressed;
  final VoidCallback? pinOnPressed;
  final VoidCallback? reportOnPressed;
  final VoidCallback? blockOnPressed;
  final VoidCallback? unPinOnPressed;
  final VoidCallback? unSaveOnPressed;
  final VoidCallback? deleteOnPressed;

  VentPreviewerWidgets({
    required this.context,
    this.title = '',
    this.bodyText = '',
    this.tags,
    this.postTimestamp,
    this.isNsfw,
    this.creator,
    this.totalLikes,
    this.totalComments,
    this.pfpData,
    this.navigateVentPostPageOnPressed,
    this.editOnPressed,
    this.reportOnPressed,
    this.blockOnPressed,
    this.unPinOnPressed,
    this.unSaveOnPressed,
    this.deleteOnPressed,
    this.copyOnPressed,
    this.pinOnPressed
  });

  final navigation = getIt.navigationProvider;

  Map<String, dynamic> _getLikesInfo(dynamic ventData, int ventIndex) {

    final safeVentIndex = ventIndex == -1 ? 0 : ventIndex;

    dynamic profileData;

    if (navigation.currentRoute == AppRoute.myProfile.path) {
      profileData = ventData.myProfile;

    } else if (navigation.currentRoute == AppRoute.userProfile.path) {
      profileData = ventData.userProfile;

    }

    int totalLikes = 0;
    bool isLiked = false;

    if (RouteHelper.isOnProfile) {
      totalLikes = profileData.totalLikes.length > 0 ? profileData.totalLikes[safeVentIndex] : 0;
      isLiked = profileData.totalLikes.length > 0 ? profileData.isPostLiked[safeVentIndex] : false;

    } else {
      totalLikes = ventData.vents.length > 0 ? ventData.vents[safeVentIndex].totalLikes : 0;
      isLiked = ventData.vents.length > 0 ? ventData.vents[safeVentIndex].isPostLiked : false;
      
    }

    return {
      'total_likes': totalLikes,
      'is_liked': isLiked
    };

  }

  bool _getIsSaved(dynamic ventData, int ventIndex) {

    final safeVentIndex = ventIndex == -1 ? 0 : ventIndex;

    dynamic profileData;

    if (navigation.currentRoute == AppRoute.myProfile.path) {
      profileData = ventData.myProfile;

    } else if (navigation.currentRoute == AppRoute.userProfile.path) {
      profileData = ventData.userProfile;

    }

    if (RouteHelper.isOnProfile) {
      return profileData.isPostSaved.length > 0 ? profileData.isPostSaved[safeVentIndex] : false;
    } 

    return ventData.vents.length > 0 ? ventData.vents[safeVentIndex].isPostSaved : false;

  }

  Widget buildLikeButton() {

    final getProvider = CurrentProviderService(
      title: title!, creator: creator!
    ).getRealTimeProvider(context: context);

    final ventIndex = getProvider['vent_index'];
    final ventData = getProvider['vent_data'];

    final likesInfo = _getLikesInfo(ventData, ventIndex);

    return ActionsButton().buildLikeButton(
      value: ventIndex == -1 ? 0 : likesInfo['total_likes'],
      isLiked: ventIndex == -1 ? false : likesInfo['is_liked'],
      onPressed: () async {
        await VentActionsHandler(
          title: title!, 
          creator: creator!, 
          context: context
        ).likePost();
      }
    );
    
  }

  Widget buildSaveButton() {

    final getProvider = CurrentProviderService(
      title: title!, creator: creator!
    ).getRealTimeProvider(context: context);

    final ventIndex = getProvider['vent_index'];
    final ventData = getProvider['vent_data'];

    final isSaved = ventIndex == -1 ? false : _getIsSaved(ventData, ventIndex);

    return ActionsButton().buildSaveButton(
      isSaved: isSaved,
      onPressed: () async {
        await VentActionsHandler(
          title: title!, 
          creator: creator!, 
          context: context
        ).savePost(isSaved);
      }
    );
  
  }

  Widget buildCommentButton() {
    return ActionsButton().buildCommentsButton(
      value: totalComments!, 
      onPressed: navigateVentPostPageOnPressed!
    );
  }

  void _callVentOptionsBottomsheet() {
    BottomsheetVentPostActions().buildBottomsheet(
      context: context, 
      title: title!,
      creator: creator!,
      editOnPressed: editOnPressed,
      copyOnPressed: copyOnPressed,
      pinOnPressed: pinOnPressed,
      unPinOnPressed: unPinOnPressed,
      unSaveOnPressed: unSaveOnPressed,
      reportOnPressed: reportOnPressed,
      blockOnPressed: blockOnPressed,
      deleteOnPressed: deleteOnPressed
    );
  }

  Widget buildVentOptionsButton({Widget? customIconWidget}) {
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: SizedBox(
        width: 25,
        height: 25,
        child: IconButton(
          onPressed: () => _callVentOptionsBottomsheet(),
          icon: customIconWidget ?? Transform.translate(
            offset: const Offset(0, -10),
            child: Icon(CupertinoIcons.ellipsis, color: ThemeColor.contentThird, size: 18)
          )
        ),
      ),
    );
  }

  Widget buildHeaders() {

    final disableGoToProfile = 
      RouteHelper.isOnProfile && navigation.profileTabIndex == 0;

    return InkWellEffect(
      onPressed: () => disableGoToProfile
        ? null : NavigatePage.userProfilePage(username: creator!, pfpData: pfpData),
      child: Row(
        children: [
    
          ProfilePictureWidget(
            customWidth: 31.5,
            customHeight: 31.5,
            pfpData: pfpData,
          ),
    
          const SizedBox(width: 8),
    
          Padding(
            padding: const EdgeInsets.only(bottom: 1.5),
            child: Text(
              creator!,
              style: GoogleFonts.inter(
                color: ThemeColor.contentSecondary,
                fontWeight: FontWeight.w800,
                fontSize: 13.5
              ),
            ),
          ),
    
          const SizedBox(width: 8),
    
          Padding(
            padding: const EdgeInsets.only(bottom: 0.8),
            child: Text(
              postTimestamp!,
              style: GoogleFonts.inter(
                color: ThemeColor.contentThird,
                fontWeight: FontWeight.w800,
                fontSize: 12.5
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
        color: ThemeColor.contentPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 16
      ),
      overflow: bodyText!.isEmpty ? TextOverflow.ellipsis : TextOverflow.fade,
      softWrap: true,
      maxLines: 2
    );
  }

  Widget buildBodyText() {
    return StyledTextWidget(
      isSelectable: false,
      text: bodyText!,
      isPreviewer: true
    );
  }

  Widget buildTags() {
    return Text(
      tags!.split(' ').map((tags) => '#$tags').join(' '),
      style: GoogleFonts.inter(
        color: ThemeColor.contentThird,
        fontWeight: FontWeight.w700,
        fontSize: 13
      ),
    );
  }

  Widget buildMainContainer({required List<Widget> children}) {
    return InkWellEffect(
      onLongPress: () => _callVentOptionsBottomsheet(),
      onPressed: navigateVentPostPageOnPressed!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: ThemeColor.divider,
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