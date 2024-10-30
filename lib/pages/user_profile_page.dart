import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/data_query/user_actions.dart';
import 'package:revent/data_query/user_following.dart';
import 'package:revent/data_query/user_profile/profile_data_getter.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/bottomsheet_widgets/user_actions.dart';
import 'package:revent/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/widgets/buttons/main_button.dart';
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

  final followersNotifier = ValueNotifier<int>(0);
  final followingNotifier = ValueNotifier<int>(0);
  final postsNotifier = ValueNotifier<int>(0);
  final bioNotifier = ValueNotifier<String>('');
  final pronounsNotifier = ValueNotifier<String>('');

  final isFollowingNotifier = ValueNotifier<bool>(false);

  late ProfileInfoWidgets profileInfoWidgets;
  late ProfileTabBarWidgets tabBarWidgets;
  late TabController tabController;

  Future<void> _setProfileData() async {

    final getProfileData = await ProfileDataGetter()
      .getProfileData(isMyProfile: false, username: widget.username);
    
    postsNotifier.value = getProfileData['posts'];
    followersNotifier.value = getProfileData['followers']; 
    followingNotifier.value = getProfileData['following'];
    bioNotifier.value =  getProfileData['bio'];
    pronounsNotifier.value =  getProfileData['pronouns'];

    isFollowingNotifier.value = await UserFollowing().isFollowing(username: widget.username);

  }

  void _followUserOnPressed() async {

    isFollowingNotifier.value 
      ? await UserActions(username: widget.username).userFollowAction(follow: false)
      : await UserActions(username: widget.username).userFollowAction(follow: true);

    isFollowingNotifier.value = !isFollowingNotifier.value;

  }

  Widget _buildPronouns(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: ValueListenableBuilder(
        valueListenable: pronounsNotifier,
        builder: (_, value, __) {
          final bottomPadding = value.isNotEmpty ? 14.0 : 0.0; 
          final topPadding = value.isNotEmpty ? 8.0 : 0.0;
          return Padding(
            padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
            child: Text(
              value,
              style: ThemeStyle.profilePronounsStyle,
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: ValueListenableBuilder(
        valueListenable: bioNotifier,
        builder: (_, value, __) {
          return Text(
            value,
            style: ThemeStyle.profileBioStyle,
            textAlign: TextAlign.center,
            maxLines: 3,
          );
        },
      ),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {

    final buttonWidth = MediaQuery.of(context).size.width * 0.45;
    final buttonHeight = MediaQuery.of(context).size.height * 0.050;
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

  Widget _popularityWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
    
          GestureDetector(
            onTap: () => NavigatePage.followsPage(pageType: 'Followers', username: widget.username),
            child: profileInfoWidgets.buildPopularityHeaderNotifier('followers', followersNotifier)
          ),

          profileInfoWidgets.buildPopularityHeaderNotifier('posts', postsNotifier),

          GestureDetector(
            onTap: () => NavigatePage.followsPage(pageType: 'Following', username: widget.username),
            child: profileInfoWidgets.buildPopularityHeaderNotifier('following', followingNotifier)
          ),
    
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
    
          profileInfoWidgets.buildProfilePicture(),
          
          const SizedBox(height: 12),
    
          profileInfoWidgets.buildUsername(),
    
          _buildPronouns(context),

          _buildBio(context),
    
          const SizedBox(height: 25),
    
          _buildEditProfileButton(context),

          const SizedBox(height: 28),

          _popularityWidgets(context),

          tabBarWidgets.buildTabBar(),

          tabBarWidgets.buildTabBarTabs()

        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return IconButton(
      icon: const Icon(CupertinoIcons.ellipsis_vertical, size: 22),
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
    profileInfoWidgets = ProfileInfoWidgets(context: context, username: widget.username, pfpData: widget.pfpData);
    tabController = TabController(length: 2, vsync: this);
    tabBarWidgets = ProfileTabBarWidgets(context: context, controller: tabController);
  }

  @override
  void dispose() {
    followersNotifier.dispose();
    followingNotifier.dispose();
    postsNotifier.dispose();
    bioNotifier.dispose();
    pronounsNotifier.dispose();
    isFollowingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: '',
        actions: [_buildActionButton()]
      ).buildAppBar(),
      body: RefreshIndicator(
        color: ThemeColor.mediumBlack,
        onRefresh: () async => await _setProfileData(),
        child: _buildBody(context)
      ),
      bottomNavigationBar: UpdateNavigation(
        context: context,
      ).showNavigationBar(),
    );
  }
  
}