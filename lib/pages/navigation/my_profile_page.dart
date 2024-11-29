import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revent/data_query/user_profile/profile_posts_setup.dart';
import 'package:revent/helper/call_refresh.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/profile/edit_profile_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/provider/profile/profile_saved_provider.dart';
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
  final navigation = GetIt.instance<NavigationProvider>();

  final profilePostsData = GetIt.instance<ProfilePostsProvider>();
  final profileSavedData = GetIt.instance<ProfileSavedProvider>();

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

  void _initializePostsData() async {

    final callProfilePosts = ProfilePostsSetup(
      userType: 'my_profile',
      username: userData.user.username
    );

    await callProfilePosts.setupPosts();
    await callProfilePosts.setupSaved();

  }

  Widget _buildPronouns() {
    return Consumer<ProfileDataProvider>(
      builder: (_, profileData, __) {
        final bottomPadding = profileData.pronouns.isNotEmpty ? 11.0 : 0.0;
        final topPadding = profileData.pronouns.isNotEmpty ? 5.0 : 0.0;
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
            ? Transform.translate(
              offset: Offset(0, profileData.pronouns.isEmpty ? -5 : -2),
              child: const Text(
                'No bio yet...',
                style: ThemeStyle.profileEmptyBioStyle,
                textAlign: TextAlign.start,
              ),
            )
            : GestureDetector(
              onTap: () => NavigatePage.fullBioPage(bio: profileData.bio),
              child: Text(
                profileData.bio,
                style: ThemeStyle.profileBioStyle,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
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
                
                profileInfoWidgets.buildPopularityHeader('vents', postsData.myProfile.titles.length),

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
          onRefresh: () async => await CallRefresh().refreshMyProfile(),
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
      onPressed: () {}
    );
  }

  @override
  void initState() {
    super.initState();
    navigation.setCurrentRoute('/profile/my_profile/');
    _initializePostsData();
    _initializeClasses();
    tabController.addListener(() {
      navigation.setProfileTabIndex(tabController.index);
    });
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
        bottomNavigationBar: PageNavigationBar()
      ),
    );
  }
  
}