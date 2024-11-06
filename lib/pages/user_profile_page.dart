import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_actions.dart';
import 'package:revent/data_query/user_following.dart';
import 'package:revent/data_query/user_profile/profile_data_getter.dart';
import 'package:revent/data_query/user_profile/profile_posts_getter.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/provider/profile_posts_provider.dart';
import 'package:revent/themes/theme_style.dart';
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

  final followersNotifier = ValueNotifier<int>(0);
  final followingNotifier = ValueNotifier<int>(0);
  final postsNotifier = ValueNotifier<int>(0);
  final bioNotifier = ValueNotifier<String>('');
  final pronounsNotifier = ValueNotifier<String>('');

  final isFollowingNotifier = ValueNotifier<bool>(false);

  late ProfileInfoWidgets profileInfoWidgets;
  late ProfileTabBarWidgets tabBarWidgets;
  late TabController tabController;

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
      pfpData: widget.pfpData
    );
  }

  Future<void> _setPostsData() async {

    final getPostsData = await ProfilePostsGetter()
      .getPosts(username: widget.username);

    final title = getPostsData['title'] as List<String>;
    final totalLikes = getPostsData['total_likes'] as List<int>;

    profilePostsData.setUserProfileTitles(title);
    profilePostsData.setUserProfileTotalLikes(totalLikes);

  }

  Future<void> _setProfileData() async {

    final getProfileData = await ProfileDataGetter()
      .getProfileData(isMyProfile: false, username: widget.username);
        
    followersNotifier.value = getProfileData['followers']; 
    followingNotifier.value = getProfileData['following'];
    bioNotifier.value =  getProfileData['bio'];
    pronounsNotifier.value =  getProfileData['pronouns'];

    isFollowingNotifier.value = await UserFollowing().isFollowing(username: widget.username);

    final getPostsData = await ProfilePostsGetter()
      .getPosts(username: widget.username);

    final title = getPostsData['title'] as List<String>;
    final totalLikes = getPostsData['total_likes'] as List<int>;

    profilePostsData.setUserProfileTitles(title);
    profilePostsData.setUserProfileTotalLikes(totalLikes);
    
    postsNotifier.value = profilePostsData.userProfileTitles.length;

  }

  void _followUserOnPressed() async {

    isFollowingNotifier.value 
      ? await UserActions(username: widget.username).userFollowAction(follow: false)
      : await UserActions(username: widget.username).userFollowAction(follow: true);

    isFollowingNotifier.value = !isFollowingNotifier.value;

  }

  Widget _buildPronouns() {
    return ValueListenableBuilder(
      valueListenable: pronounsNotifier,
      builder: (_, value, __) {
        final bottomPadding = value.isNotEmpty ? 14.0 : 0.0; 
        final topPadding = value.isNotEmpty ? 8.0 : 0.0;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),          
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text(
              value,
              style: ThemeStyle.profilePronounsStyle,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBio() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: ValueListenableBuilder(
        valueListenable: bioNotifier,
        builder: (_, bio, __) {
          return bio.isEmpty 
            ? const Text(
              'No bio yet...',
              style: ThemeStyle.profileEmptyBioStyle,
              textAlign: TextAlign.center
            )
            : Text(
              bio,
              style: ThemeStyle.profileBioStyle,
              textAlign: TextAlign.center,
              maxLines: 3,
            );
        },
      ),
    );
  }

  Widget _buildEditProfileButton() {

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

  Widget _popularityWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
    
          GestureDetector(
            onTap: () => NavigatePage.followsPage(pageType: 'Followers', username: widget.username),
            child: profileInfoWidgets.buildPopularityHeaderNotifier('followers', followersNotifier)
          ),

          profileInfoWidgets.buildPopularityHeaderNotifier('vents', postsNotifier),

          GestureDetector(
            onTap: () => NavigatePage.followsPage(pageType: 'Following', username: widget.username),
            child: profileInfoWidgets.buildPopularityHeaderNotifier('following', followingNotifier)
          ),
    
        ],
      ),
    );
  }

  Widget _buildBody() {
    return ValueListenableBuilder(
      valueListenable: pronounsNotifier,
      builder: (_, pronouns, __) {
        return ProfileBodyWidgets(
          onRefresh: () async => await _setProfileData(),
          isPronounsNotEmpty: pronouns.isNotEmpty, 
          tabBarWidgets: tabBarWidgets, 
          profileInfoWidgets: profileInfoWidgets, 
          pronounsWidget: _buildPronouns(), 
          bioWidget: _buildBio(), 
          userActionButtonWidget: _buildEditProfileButton(), 
          popularityWidget: _popularityWidgets()
        );      
      }
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
    _setPostsData();
    _setProfileData();
    _initializeClasses();
  }

  @override
  void dispose() {
    followersNotifier.dispose();
    followingNotifier.dispose();
    postsNotifier.dispose();
    bioNotifier.dispose();
    pronounsNotifier.dispose();
    isFollowingNotifier.dispose();
    tabController.dispose();
    profilePostsData.userProfileTitles.clear();
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
      body: _buildBody(),
      bottomNavigationBar: UpdateNavigation(
        context: context,
      ).showNavigationBar(),
    );
  }
  
}