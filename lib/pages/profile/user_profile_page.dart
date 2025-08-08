import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/profile_type.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/service/query/user/user_block_getter.dart';
import 'package:revent/service/query/user/user_data_getter.dart';
import 'package:revent/service/query/user/user_follow_status.dart';
import 'package:revent/service/query/user/user_privacy_actions.dart';
import 'package:revent/service/query/user_profile/profile_data_getter.dart';
import 'package:revent/model/setup/profile_posts_setup.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/service/user/user_profile_actions.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/user/view_full_bio.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/navigation/navigation_bar_dock.dart';
import 'package:revent/shared/widgets/profile/social_links_widget.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/shared/widgets/buttons/main_button.dart';
import 'package:revent/shared/widgets/profile/profile_body_widgets.dart';
import 'package:revent/shared/widgets/profile/profile_info_widgets.dart';
import 'package:revent/shared/widgets/profile/tabbar_widgets.dart';

class UserProfilePage extends StatefulWidget {

  final String username;
  final Uint8List pfpData;

  const UserProfilePage({
    required this.username,
    required this.pfpData,
    super.key
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();

}

class _UserProfilePageState extends State<UserProfilePage> with 
  SingleTickerProviderStateMixin, 
  ProfilePostsProviderService,
  NavigationProviderService {

  final followersNotifier = ValueNotifier<int>(0);
  final followingNotifier = ValueNotifier<int>(0);
  final postsNotifier = ValueNotifier<int>(0);
  final bioNotifier = ValueNotifier<String>('');
  final pronounsNotifier = ValueNotifier<String>('');

  final isFollowingNotifier = ValueNotifier<bool>(false);
  final socialHandlesNotifier = ValueNotifier<Map<String, String>>({});

  final profileDataGetter = ProfileDataGetter();
  final userDataGetter = UserDataGetter();
  final userFollowStatus = UserFollowStatus();

  late ProfilePostsSetup profilePostsSetup;
  late ProfileInfoWidgets profileInfoWidgets;
  late ProfileTabBarWidgets tabBarWidgets;
  late TabController tabController;

  bool isBlockedAccount = false;
  bool isPrivateAccount = false;
  bool isFollowingListHidden = false;
  bool isSavedPostsHidden = false;

  String joinedDate = '';

  void _initializeClasses() async {
    
    profilePostsSetup = ProfilePostsSetup(
      profileType: ProfileType.userProfile,
      username: widget.username,
    );

    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(
      () => _onTabChanged()
    );

    profileInfoWidgets = ProfileInfoWidgets(
      username: widget.username, 
      pfpData: widget.pfpData
    );
        
    tabBarWidgets = ProfileTabBarWidgets(
      controller: tabController, 
      isMyProfile: false,
      username: widget.username,
      pfpData: widget.pfpData,
      isSavedHidden: isSavedPostsHidden
    );

  }

  void _onTabChanged() async {

    if (tabController.index == 1) {

      if (isSavedPostsHidden) {
        SnackBarDialog.temporarySnack(message: AlertMessages.followingHidden);
      }

      if (!isSavedPostsHidden) {
        await profilePostsSetup.setupSaved();
      }

    }

    setState(
      () => navigationProvider.setProfileTabIndex(tabController.index)
    );

  }

  Future<String> _initializeJoinDate() async {

    if (joinedDate.isEmpty) {

      final getJoinedDate = await userDataGetter.getJoinedDate(
        username: widget.username
      );

      final formattedJoinedDate = FormatDate.formatLongDate(getJoinedDate);

      joinedDate = formattedJoinedDate;

      return formattedJoinedDate;

    } 

    return joinedDate;

  }

  Future<void> _initializePrivacySettings() async {

    final privacyOptions = await UserPrivacyActions().getCurrentPrivacyOptions(
      username: widget.username
    );

    isPrivateAccount = privacyOptions['account'] != 0;
    isFollowingListHidden = privacyOptions['following'] != 0;
    isSavedPostsHidden = privacyOptions['saved'] != 0;

  }

  Future<void> _initializeRestrictedView() async {

    final profileData = await profileDataGetter.getProfileData(
      isMyProfile: false, username: widget.username
    );
        
    followersNotifier.value = profileData['followers']; 
    followingNotifier.value = profileData['following'];
    bioNotifier.value = isBlockedAccount ? '' : profileData['bio'];
    pronounsNotifier.value =  isBlockedAccount ? '' : profileData['pronouns'];

    isFollowingNotifier.value = await userFollowStatus.isFollowing(username: widget.username);
    
    postsNotifier.value = 0;

  }

  Future<void> _initializeBasicProfileInfo() async {

    final profileData = await profileDataGetter.getProfileData(
      isMyProfile: false, username: widget.username
    );
        
    followersNotifier.value = profileData['followers']; 
    followingNotifier.value = profileData['following'];
    bioNotifier.value =  profileData['bio'];
    pronounsNotifier.value =  profileData['pronouns'];

  }

  Future<void> _initializeCompleteProfileData() async {

    try {

      isBlockedAccount = await UserBlockGetter(username: widget.username).getIsAccountBlocked();

      if (isBlockedAccount) {
        setState(() {});
        await _initializeRestrictedView();
        return;
      }

      await _initializePrivacySettings();

      if (isPrivateAccount) {
        await _initializeRestrictedView();
        return;
      }

      _initializeBasicProfileInfo();

      profilePostsProvider.userProfile.clear();
      profileSavedProvider.userProfile.clear();

      await profilePostsSetup.setupPosts();
      
      postsNotifier.value = profilePostsProvider.userProfile.titles.length;

      isFollowingNotifier.value = await userFollowStatus.isFollowing(username: widget.username);
      socialHandlesNotifier.value = await userDataGetter.getSocialHandles(username: widget.username);

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }

  Future<void> _onFollowUserPressed() async {

    try {

      final follow = !isFollowingNotifier.value;

      if (!follow) {
        
        CustomAlertDialog.alertDialogCustomOnPress(
          message: "Unfollow @${widget.username}?", 
          buttonMessage: "Unfollow", 
          onPressedEvent: () async {
            await _toggleFollowUser(follow).then(
              (_) => Navigator.pop(context)
            );
          }
        );

        return;

      }

      await _toggleFollowUser(follow);

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }

  Future<void> _toggleFollowUser(bool follow) async {
    await UserActions(username: widget.username).toggleFollowUser(follow: true).then(
      (_) => isFollowingNotifier.value = !isFollowingNotifier.value
    );
  }

  Widget _buildPronouns() {
    return ValueListenableBuilder(
      valueListenable: pronounsNotifier,
      builder: (_, value, __) {
        final bottomPadding = value.isNotEmpty ? 11.0 : 0.0; 
        final topPadding = value.isNotEmpty ? 5.0 : 0.0;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),  
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text(
              value,
              style: ThemeStyle.profilePronounsStyle,
              textAlign: TextAlign.start,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBio() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.68,
      child: ValueListenableBuilder(
        valueListenable: bioNotifier,
        builder: (_, bio, __) {
          return bio.isEmpty
            ? Transform.translate(
              offset: Offset(0, pronounsNotifier.value.isEmpty ? -5 : -2),
              child: Text(
                'No bio yet...',
                style: ThemeStyle.profileEmptyBioStyle,
                textAlign: TextAlign.start
              ),
            )
            : Transform.translate(
              offset: Offset(0, pronounsNotifier.value.isEmpty ? -5 : -2),
                child: GestureDetector(
                onTap: () => BottomsheetViewFullBio().buildBottomsheet(context: context, bio: bio),
                child: Text(
                  bio,
                  style: ThemeStyle.profileBioStyle,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            );  
        },
      ),
    );
  }

  Widget _buildFollowButton() {

    final buttonWidth = MediaQuery.of(context).size.width * 0.87;
    const buttonHeight = 45.0;
    
    const fontSize = 15.5;

    return Align(
      alignment: Alignment.center,
      child: ValueListenableBuilder(
        valueListenable: isFollowingNotifier,
        builder: (_, isFollowing, __) {
          return isFollowing 
          ? CustomOutlinedButton(
            customWidth: buttonWidth,
            customHeight: buttonHeight,
            customFontSize: fontSize,
            text: 'Following',
            onPressed: () async => await _onFollowUserPressed()
          )
          : MainButton(
            customWidth: buttonWidth,
            customHeight: buttonHeight,
            customFontSize: fontSize,
            text: 'Follow',
            onPressed: () async => await _onFollowUserPressed()
          );
        },
      ),
    );

  }

  Widget _popularityWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
  
        profileInfoWidgets.buildPopularityHeaderNotifier('Vents', postsNotifier),

        GestureDetector(
          onTap: () => isPrivateAccount || isBlockedAccount 
            ? null 
            : NavigatePage.followsPage(
              pageType: 'Followers', 
              username: widget.username, 
              totalFollowers: followersNotifier.value, 
              totalFollowing: followingNotifier.value, 
              isFollowingListHidden: isFollowingListHidden
            ),
          child: profileInfoWidgets.buildPopularityHeaderNotifier('Followers', followersNotifier)
        ),

        GestureDetector(
          onTap: () => isPrivateAccount || isBlockedAccount || isFollowingListHidden
            ? (isFollowingListHidden ? SnackBarDialog.temporarySnack(message: AlertMessages.followingHidden) : null) 
            : NavigatePage.followsPage(
              pageType: 'Following', 
              username: widget.username, 
              totalFollowers: followersNotifier.value, 
              totalFollowing: followingNotifier.value, 
              isFollowingListHidden: isFollowingListHidden
            ),
          child: profileInfoWidgets.buildPopularityHeaderNotifier('Following', followingNotifier)
        ),
  
      ],
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder(
      valueListenable: pronounsNotifier,
      builder: (_, pronouns, __) {
        return ProfileBodyWidgets(
          onRefresh: () async => await _initializeCompleteProfileData(),
          tabBarWidgets: tabBarWidgets,
          profileInfoWidgets: profileInfoWidgets, 
          pronounsWidget: _buildPronouns(),
          bioWidget: _buildBio(),
          userActionButtonWidget: _buildFollowButton(), 
          popularityWidget: _popularityWidgets(),
          isPrivateAccount: isPrivateAccount,
          isBlockedAccount: isBlockedAccount,
        );      
      }
    );
  }

  Widget _buildOptionsActionButton() {
    return IconButton(
      icon: Icon(CupertinoIcons.ellipsis_circle, size: 25, color: ThemeColor.contentPrimary),
      onPressed: () {
        UserProfileActions(context: context).showUserActions(
          username: widget.username, 
          pronouns: pronounsNotifier.value, 
          pfpData: widget.pfpData, 
          loadJoinedDate: _initializeJoinDate
        );
      }
    );
  }

  Widget _buildSocialLinks() {
    return ValueListenableBuilder(
      valueListenable: socialHandlesNotifier,
      builder: (_, socialHandles, __) {
        return SocialLinksWidgets(
          socialHandles: socialHandles
        ).buildSocialLinks();
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeClasses();
    _initializeCompleteProfileData();
  }

  @override
  void dispose() {
    navigationProvider.setProfileTabIndex(0);
    navigationProvider.setCurrentRoute(AppRoute.home);
    followersNotifier.dispose();
    followingNotifier.dispose();
    postsNotifier.dispose();
    bioNotifier.dispose();
    pronounsNotifier.dispose();
    isFollowingNotifier.dispose();
    socialHandlesNotifier.dispose();
    tabController.dispose();
    profilePostsProvider.clearPostsData();
    profileSavedProvider.clearPostsData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        actions: [_buildSocialLinks(), _buildOptionsActionButton()]
      ).buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: NavigationBarDock()
    );
  }
  
}