import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_query/user_actions.dart';
import 'package:revent/data_query/user_following.dart';
import 'package:revent/data_query/user_profile/profile_data_getter.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/ui_dialog/profile_picture_dialog.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/bottomsheet_widgets/user_actions.dart';
import 'package:revent/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/widgets/buttons/main_button.dart';
import 'package:revent/widgets/custom_tab_bar.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile/my_posts_listview.dart';
import 'package:revent/widgets/profile_picture.dart';

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

  late  TabController tabController;

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

  Widget _buildUsername() {
    return Text(
      widget.username,
      style: ThemeStyle.profileUsernameStyle
    );
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

  Widget _buildPopularityHeader(String header, ValueNotifier notifierValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        ValueListenableBuilder(
          valueListenable: notifierValue,
          builder: (_, value, __) {
            return Text(
              value.toString(),
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 20
              ),
            );
          },
        ),

        const SizedBox(height: 4),

        Text(
          header,
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w700,
            fontSize: 14.5
          ),
        ),

      ],
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
            child: _buildPopularityHeader('followers', followersNotifier)
          ),

          _buildPopularityHeader('posts', postsNotifier),

          GestureDetector(
            onTap: () => NavigatePage.followsPage(pageType: 'Following', username: widget.username),
            child: _buildPopularityHeader('following', followingNotifier)
          ),
    
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return InkWellEffect(
      onPressed: () => ProfilePictureDialog().showPfpDialog(context, widget.pfpData),
      child: ProfilePictureWidget(
        customHeight: 75,
        customWidth: 75,
        pfpData: widget.pfpData,
      ),
    );
  }

  Widget _buildMyVentPostsTab() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 28,
      child: const MyPostsListView(),
    );
  }

  Widget _buildTabBarTabs() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5, 
      child: TabBarView(
        controller: tabController,
        children: [
          _buildMyVentPostsTab(), 
          Container(),           
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: CustomTabBar(
        controller: tabController, 
        tabAlignment: TabAlignment.fill,
        tabs: const [
          Tab(icon: Icon(CupertinoIcons.square_grid_2x2, size: 20)),
          Tab(icon: Icon(CupertinoIcons.bookmark, size: 20)),
        ],
      ).buildTabBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
    
          _buildProfilePicture(),
          
          const SizedBox(height: 12),
    
          _buildUsername(),
    
          _buildPronouns(context),

          _buildBio(context),
    
          const SizedBox(height: 25),
    
          _buildEditProfileButton(context),

          const SizedBox(height: 28),

          _popularityWidgets(context),

          _buildTabBar(),

          _buildTabBarTabs()

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
    tabController = TabController(length: 2, vsync: this);
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