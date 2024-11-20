import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revent/data_query/user_profile/profile_posts_getter.dart';
import 'package:revent/helper/call_refresh.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/edit_profile_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/profile_posts_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/widgets/profile/profile_body_widgets.dart';
import 'package:revent/widgets/profile/profile_info_widgets.dart';
import 'package:revent/widgets/profile/tabbar_widgets.dart';

class MyProfilePage extends StatefulWidget {

  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => MyProfilePageState();

}

class MyProfilePageState extends State<MyProfilePage> with SingleTickerProviderStateMixin {

  final navigationIndex = GetIt.instance<NavigationProvider>();
  final userData = GetIt.instance<UserDataProvider>();
  final profileData = GetIt.instance<ProfileDataProvider>();
  final profilePostsData = GetIt.instance<ProfilePostsProvider>();

  late ProfileInfoWidgets profileInfoWidgets;
  late ProfileTabBarWidgets tabBarWidgets;
  late TabController tabController;

  void _initializeClasses() {
    tabController = TabController(length: 2, vsync: this);
    profileInfoWidgets = ProfileInfoWidgets(
      username: userData.user.username, 
      pfpData: profileData.profilePicture
    );
    tabBarWidgets = ProfileTabBarWidgets(
      controller: tabController, 
      isMyProfile: true, 
      username: userData.user.username, 
      pfpData: profileData.profilePicture
    );
  }

  Future<void> _setPostsData() async {

    if(profilePostsData.myProfileTitles.isEmpty) {

      final getPostsData = await ProfilePostsGetter()
        .getPosts(username: userData.user.username);

      final title = getPostsData['title'] as List<String>;
      final totalLikes = getPostsData['total_likes'] as List<int>;

      profilePostsData.setMyProfileTitles(title);
      profilePostsData.setMyProfileTotalLikes(totalLikes);

    } 

  }

  Widget _buildPronouns() {
    return Consumer<ProfileDataProvider>(
      builder: (_, profileData, __) {
        final bottomPadding = profileData.pronouns.isNotEmpty ? 12.0 : 0.0;
        final topPadding = profileData.pronouns.isNotEmpty ? 6.0 : 0.0;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text(
              profileData.pronouns,
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
      child: Consumer<ProfileDataProvider>(
        builder: (_, profileData, __) {
          return profileData.bio.isEmpty
            ? const Text(
              'No bio yet...',
              style: ThemeStyle.profileEmptyBioStyle,
              textAlign: TextAlign.start,
            )
            : GestureDetector(
              onTap: () => NavigatePage.fullBioPage(bio: profileData.bio),
              child: Text(
                profileData.bio,
                style: ThemeStyle.profileBioStyle,
                textAlign: TextAlign.start,
                overflow: TextOverflow.fade,
                maxLines: 2,
              ),
            );
        },
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return Align(
      alignment: Alignment.center,
      child: CustomOutlinedButton(
        customWidth: MediaQuery.of(context).size.width * 0.87,
        customHeight: MediaQuery.of(context).size.height * 0.052,
        customFontSize: 15.5,
        text: 'Edit profile',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditProfilePage())
          );
        }
      ),
    );
  }

  Widget _popularityWidgets() {
    return Consumer<ProfileDataProvider>(
      builder: (_, profileData, __) {
        return Consumer<ProfilePostsProvider>(
          builder: (_, postsData, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                profileInfoWidgets.buildPopularityHeader('vents', postsData.myProfileTitles.length),

                GestureDetector(
                  onTap: () => NavigatePage.followsPage(pageType: 'Followers', username: userData.user.username),
                  child: profileInfoWidgets.buildPopularityHeader('followers', profileData.followers)
                ),
          
                GestureDetector(
                  onTap: () => NavigatePage.followsPage(pageType: 'Following', username: userData.user.username),
                  child: profileInfoWidgets.buildPopularityHeader('following', profileData.following)
                ),
          
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return Consumer<ProfileDataProvider>(
      builder: (_, profileData, __) {
        return ProfileBodyWidgets(
          onRefresh: () async => await CallRefresh().refreshMyProfile(username: userData.user.username),
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
      icon: const Icon(CupertinoIcons.bars, size: 28),
      onPressed: () => NavigatePage.settingsPage()
    );
  }

  Widget _buildLeadingButton() {
    return IconButton(
      icon: const Icon(CupertinoIcons.lock, size: 24),
      onPressed: () => print('Pressed')
    );
  }

  @override
  void initState() {
    super.initState();
    _setPostsData();
    _initializeClasses();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    navigationIndex.setPageIndex(4);
    return WillPopScope(
      onWillPop: () async {
        NavigatePage.homePage();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          context: context, 
          title: '',
          customLeading: _buildLeadingButton(),
          actions: [_buildActionButton()]
        ).buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: UpdateNavigation(
          context: context,
        ).showNavigationBar(),
      ),
    );
  }
  
}