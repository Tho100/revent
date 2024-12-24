import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/model/setup/profile_posts_setup.dart';
import 'package:revent/helper/call_refresh.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/main.dart';
import 'package:revent/pages/profile/edit_profile_page.dart';
import 'package:revent/pages/setttings/privacy_page.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/bottomsheet_widgets/view_full_bio.dart';
import 'package:revent/shared/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/shared/provider/profile/profile_data_provider.dart';
import 'package:revent/shared/provider/profile/profile_posts_provider.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/shared/widgets/profile/profile_body_widgets.dart';
import 'package:revent/shared/widgets/profile/profile_info_widgets.dart';
import 'package:revent/shared/widgets/profile/tabbar_widgets.dart';

class MyProfilePage extends StatefulWidget {

  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();

}

class _MyProfilePageState extends State<MyProfilePage> with SingleTickerProviderStateMixin {

  final navigation = getIt.navigationProvider;

  final userData = getIt.userProvider;
  final profileData = getIt.profileProvider;

  final profilePostsData = getIt.profilePostsProvider;
  final profileSavedData = getIt.profileSavedProvider;

  late ProfilePostsSetup callProfilePosts;
  late ProfileInfoWidgets profileInfoWidgets;
  late ProfileTabBarWidgets tabBarWidgets;
  late TabController tabController;

  void _initializeClasses() {

    callProfilePosts = ProfilePostsSetup(
      userType: 'my_profile',
      username: userData.user.username
    );

    tabController = TabController(length: 2, vsync: this);
    
    tabController.addListener(() => _onTabChanged());

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

  void _onTabChanged() async {

    if(tabController.index == 1) {
      await callProfilePosts.setupSaved();
    }

    setState(() {
      navigation.setProfileTabIndex(tabController.index);
    });

  }

  void _initializePostsData() async {

    try {

      await callProfilePosts.setupPosts();

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Something went wrong.');
    }

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
            : Transform.translate(
              offset: Offset(0, profileData.pronouns.isEmpty ? -5 : -2),
              child: GestureDetector(
              onTap: () => BottomsheetViewFullBio().buildBottomsheet(context: context, bio: profileData.bio),
                child: Text(
                  profileData.bio,
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

  Widget _buildEditProfileButton() {
    return Align(
      alignment: Alignment.center,
      child: CustomOutlinedButton(
        customWidth: MediaQuery.of(context).size.width * 0.87,
        customHeight: 45.0,
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

  Widget _buildSettingsActionButton() {
    return IconButton(
      icon: const Icon(CupertinoIcons.bars, size: 28),
      onPressed: () => NavigatePage.settingsPage()
    );
  }

  Widget _buildPrivacyLeadingButton() {
    return IconButton(
      icon: const Icon(CupertinoIcons.lock, size: 24),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrivacyPage())
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeClasses();
    _initializePostsData();
  }

  @override
  void dispose() {
    navigation.setProfileTabIndex(0);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigatePage.homePage();
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          context: context, 
          customLeading: _buildPrivacyLeadingButton(),
          actions: [_buildSettingsActionButton()]
        ).buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: PageNavigationBar()
      ),
    );
  }
  
}