import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_actions.dart';
import 'package:revent/data_query/user_following.dart';
import 'package:revent/data_query/user_privacy_actions.dart';
import 'package:revent/data_query/user_profile/profile_data_getter.dart';
import 'package:revent/helper/setup/profile_posts_setup.dart';
import 'package:revent/helper/app_route.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/widgets/bottomsheet_widgets/view_full_bio.dart';
import 'package:revent/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/provider/profile/profile_saved_provider.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/bottomsheet_widgets/user_actions.dart';
import 'package:revent/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/widgets/buttons/main_button.dart';
import 'package:revent/widgets/profile/profile_body_widgets.dart';
import 'package:revent/widgets/profile/profile_info_widgets.dart';
import 'package:revent/widgets/profile/tabbar_widgets.dart';

class UserProfilePage extends StatefulWidget {

  final String username;
  final Uint8List pfpData;

  const UserProfilePage({
    required this.username,
    required this.pfpData,
    super.key
  });

  @override
  State<UserProfilePage> createState() => UserProfilePageState();

}

class UserProfilePageState extends State<UserProfilePage> with SingleTickerProviderStateMixin {

  final profilePostsData = GetIt.instance<ProfilePostsProvider>();
  final profileSavedData = GetIt.instance<ProfileSavedProvider>();
  final navigation = GetIt.instance<NavigationProvider>();

  final followersNotifier = ValueNotifier<int>(0);
  final followingNotifier = ValueNotifier<int>(0);
  final postsNotifier = ValueNotifier<int>(0);
  final bioNotifier = ValueNotifier<String>('');
  final pronounsNotifier = ValueNotifier<String>('');

  final isFollowingNotifier = ValueNotifier<bool>(false);

  late ProfileInfoWidgets profileInfoWidgets;
  late ProfileTabBarWidgets tabBarWidgets;
  late TabController tabController;

  bool isPrivateAccount = false;

  void _initializeClasses() {
    tabController = TabController(length: 2, vsync: this);
    profileInfoWidgets = ProfileInfoWidgets(
      username: widget.username, 
      pfpData: widget.pfpData
    );
    tabBarWidgets = ProfileTabBarWidgets(
      controller: tabController, 
      isMyProfile: false,
      username: widget.username,
      pfpData: widget.pfpData,
    );
  }

  Future<void> _isPrivateAccount() async {

    final getCurrentOptions = await UserPrivacyActions().getCurrentOptions(
      username: widget.username
    );

    isPrivateAccount = getCurrentOptions['account'] != 0;

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

  Future<void> _setProfileData() async {

    try {

      await _isPrivateAccount();

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

      final callProfilePosts = ProfilePostsSetup(
        userType: 'user_profile',
        username: widget.username
      );

      await callProfilePosts.setupPosts();
      await callProfilePosts.setupSaved();
      
      postsNotifier.value = profilePostsData.userProfile.titles.length;

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }

  }

  void _followUserOnPressed() async {

    try {

      isFollowingNotifier.value 
        ? await UserActions(username: widget.username).userFollowAction(follow: false)
        : await UserActions(username: widget.username).userFollowAction(follow: true);

      isFollowingNotifier.value = !isFollowingNotifier.value;

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
              onPressed: () => _followUserOnPressed()
            )
            : MainButton(
              customWidth: buttonWidth,
              customHeight: buttonHeight,
              customFontSize: fontSize,
              text: 'Follow',
              onPressed: () => _followUserOnPressed()
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
            ? null : NavigatePage.followsPage(pageType: 'Followers', username: widget.username),
          child: profileInfoWidgets.buildPopularityHeaderNotifier('followers', followersNotifier)
        ),

        GestureDetector(
          onTap: () => isPrivateAccount 
            ? null : NavigatePage.followsPage(pageType: 'Following', username: widget.username),
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
          onRefresh: () async => await _setProfileData(),
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
        reportOnPressed: () {}, 
        blockOnPressed: () {}
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _setProfileData();
    _initializeClasses();
    tabController.addListener(() {
      setState(() {
        navigation.setProfileTabIndex(tabController.index);
      });
    });
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