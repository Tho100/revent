import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/model/user/user_follow_actions.dart';
import 'package:revent/service/query/user/user_data_getter.dart';
import 'package:revent/service/query/user/user_following.dart';
import 'package:revent/service/query/user/user_privacy_actions.dart';
import 'package:revent/service/query/user_profile/profile_data_getter.dart';
import 'package:revent/model/setup/profile_posts_setup.dart';
import 'package:revent/app/app_route.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/shared/widgets/bottomsheet/about_profile.dart';
import 'package:revent/shared/widgets/bottomsheet/view_full_bio.dart';
import 'package:revent/shared/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/user_actions.dart';
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

class _UserProfilePageState extends State<UserProfilePage> with SingleTickerProviderStateMixin {

  final profilePostsData = getIt.profilePostsProvider;
  final profileSavedData = getIt.profileSavedProvider;
  final navigation = getIt.navigationProvider;

  final followersNotifier = ValueNotifier<int>(0);
  final followingNotifier = ValueNotifier<int>(0);
  final postsNotifier = ValueNotifier<int>(0);
  final bioNotifier = ValueNotifier<String>('');
  final pronounsNotifier = ValueNotifier<String>('');

  final isFollowingNotifier = ValueNotifier<bool>(false);

  late ProfilePostsSetup callProfilePosts;
  late ProfileInfoWidgets profileInfoWidgets;
  late ProfileTabBarWidgets tabBarWidgets;
  late TabController tabController;

  bool isPrivateAccount = false;
  bool isFollowingListHidden = false;
  bool isSavedPostsHidden = false;

  String joinedDate = '';

  void _initializeClasses() async {
    
    callProfilePosts = ProfilePostsSetup(
      userType: 'user_profile',
      username: widget.username,
    );

    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() => _onTabChanged());

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

    if(tabController.index == 1) {

      if(isSavedPostsHidden) {
        SnackBarDialog.temporarySnack(message: 'Saved posts are hidden.');
      }

      if(!isSavedPostsHidden) {
        await callProfilePosts.setupSaved();
      }

    }

    setState(() { 
      navigation.setProfileTabIndex(tabController.index);
    });

  }

  Future<String> _loadJoinedDate() async {

    if(joinedDate.isEmpty) {

      final getJoinedDate = await UserDataGetter().getJoinedDate(
        username: widget.username
      );

      final formattedJoinedDate = FormatDate().formatLongDate(getJoinedDate);

      joinedDate = formattedJoinedDate;

      return formattedJoinedDate;

    } else { // TODO: Remove this else
      return joinedDate;

    }

  }

  Future<void> _loadPrivacySettings() async {

    final getCurrentOptions = await UserPrivacyActions().getCurrentOptions(
      username: widget.username
    );

    isPrivateAccount = getCurrentOptions['account'] != 0;
    isFollowingListHidden = getCurrentOptions['following'] != 0;
    isSavedPostsHidden = getCurrentOptions['saved'] != 0;

  }

  Future<void> _setPrivateAccountData() async {

    final getProfileData = await ProfileDataGetter().getProfileData(
      isMyProfile: false, username: widget.username
    );
        
    followersNotifier.value = getProfileData['followers']; 
    followingNotifier.value = getProfileData['following'];
    bioNotifier.value =  getProfileData['bio'];
    pronounsNotifier.value =  getProfileData['pronouns'];

    isFollowingNotifier.value = await UserFollowing().isFollowing(username: widget.username);
    
    postsNotifier.value = 0;

  }

  Future<void> _initializeProfileData() async {

    try {

      await _loadPrivacySettings();

      if(isPrivateAccount) {
        await _setPrivateAccountData();
        return;
      }

      final getProfileData = await ProfileDataGetter().getProfileData(
        isMyProfile: false, username: widget.username
      );
          
      followersNotifier.value = getProfileData['followers']; 
      followingNotifier.value = getProfileData['following'];
      bioNotifier.value =  getProfileData['bio'];
      pronounsNotifier.value =  getProfileData['pronouns'];

      isFollowingNotifier.value = await UserFollowing().isFollowing(username: widget.username);

      profilePostsData.userProfile.clear();
      profileSavedData.userProfile.clear();

      await callProfilePosts.setupPosts();
      
      postsNotifier.value = profilePostsData.userProfile.titles.length;

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }

  }

  Future<void> _followUserOnPressed() async {

    try {

      final follow = !isFollowingNotifier.value;

      await UserFollowActions(username: widget.username).followUser(follow: follow).then(
        (_) => isFollowingNotifier.value = !isFollowingNotifier.value
      );

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }

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
              child: const Text(
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
              onPressed: () async => await _followUserOnPressed()
            )
            : MainButton(
              customWidth: buttonWidth,
              customHeight: buttonHeight,
              customFontSize: fontSize,
              text: 'Follow',
              onPressed: () async => await _followUserOnPressed()
            );
        },
      ),
    );

  }

  Widget _popularityWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
  
        profileInfoWidgets.buildPopularityHeaderNotifier('vents', postsNotifier),

        GestureDetector(
          onTap: () => isPrivateAccount 
            ? null : NavigatePage.followsPage(pageType: 'Followers', username: widget.username, isFollowingListHidden: isFollowingListHidden),
          child: profileInfoWidgets.buildPopularityHeaderNotifier('followers', followersNotifier)
        ),

        GestureDetector(
          onTap: () => isPrivateAccount || isFollowingListHidden
            ? null : NavigatePage.followsPage(pageType: 'Following', username: widget.username, isFollowingListHidden: isFollowingListHidden),
          child: profileInfoWidgets.buildPopularityHeaderNotifier('following', followingNotifier)
        ),
  
      ],
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder(
      valueListenable: pronounsNotifier,
      builder: (_, pronouns, __) {
        return ProfileBodyWidgets(
          onRefresh: () async => await _initializeProfileData(),
          tabBarWidgets: tabBarWidgets,
          profileInfoWidgets: profileInfoWidgets, 
          pronounsWidget: _buildPronouns(),
          bioWidget: _buildBio(),
          userActionButtonWidget: _buildFollowButton(), 
          popularityWidget: _popularityWidgets(),
          isPrivateAccount: isPrivateAccount,
        );      
      }
    );
  }

  Widget _buildOptionsActionButton() {
    return IconButton(
      icon: const Icon(CupertinoIcons.ellipsis_circle, size: 25),
      onPressed: () => BottomsheetUserActions().buildBottomsheet(
        context: context, 
        aboutProfileOnPressed: () async {
          Navigator.pop(context);
          await _loadJoinedDate().then((joinedDate) {
            BottomsheetAboutProfile().buildBottomsheet(
              context: context, 
              username: widget.username, 
              pfpData: widget.pfpData,
              joinedDate: joinedDate 
            );
          });
        },
        reportOnPressed: () {}, 
        blockOnPressed: () {}
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeClasses();
    _initializeProfileData();
  }

  @override
  void dispose() {
    navigation.setProfileTabIndex(0);
    navigation.setCurrentRoute(AppRoute.home);
    followersNotifier.dispose();
    followingNotifier.dispose();
    postsNotifier.dispose();
    bioNotifier.dispose();
    pronounsNotifier.dispose();
    isFollowingNotifier.dispose();
    tabController.dispose();
    profilePostsData.clearPostsData();
    profileSavedData.clearPostsData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        actions: [_buildOptionsActionButton()]
      ).buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: PageNavigationBar()
    );
  }
  
}