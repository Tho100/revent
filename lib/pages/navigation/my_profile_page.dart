import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/profile_type.dart';
import 'package:revent/global/tabs_type.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/model/setup/profile_posts_setup.dart';
import 'package:revent/service/user/info_service.dart';
import 'package:revent/service/refresh_service.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/profile/edit_profile_page.dart';
import 'package:revent/pages/setttings/user/privacy_page.dart';
import 'package:revent/shared/provider/user_provider.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/navigation/bar_dock.dart';
import 'package:revent/shared/widgets/profile/socials_widget.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/user/full_bio_bottomsheet.dart';
import 'package:revent/shared/provider/profile/info_provider.dart';
import 'package:revent/shared/provider/profile/posts_provider.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/shared/widgets/profile/body_widgets.dart';
import 'package:revent/shared/widgets/profile/info_widgets.dart';
import 'package:revent/shared/widgets/profile/tabbar_widgets.dart';

class MyProfilePage extends StatefulWidget {

  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();

}

class _MyProfilePageState extends State<MyProfilePage> with 
  SingleTickerProviderStateMixin, 
  UserProfileProviderService,
  NavigationProviderService {

  late ProfilePostsSetup profilePostsSetup;
  late ProfileInfoWidgets profileInfoWidgets;
  late ProfileTabBarWidgets tabBarWidgets;
  late TabController tabController;

  void _initializeClasses() {

    profilePostsSetup = ProfilePostsSetup(
      profileType: ProfileType.myProfile,
      username: userProvider.user.username
    );

    tabController = TabController(length: 2, vsync: this);
    
    tabController.addListener(
      () => _onTabChanged()
    );

    profileInfoWidgets = ProfileInfoWidgets(
      username: userProvider.user.username, 
      pfpData: profileProvider.profile.profilePicture
    );

    tabBarWidgets = ProfileTabBarWidgets(
      controller: tabController, 
      isMyProfile: true, 
      username: userProvider.user.username, 
      pfpData: profileProvider.profile.profilePicture
    );

  }

  void _onTabChanged() async {

    final currentTab = ProfileTabs.values[tabController.index];

    if (currentTab == ProfileTabs.savedPosts) {
      await profilePostsSetup.setupSavedPosts();
    }

    setState(
      () => navigationProvider.setProfileTab(currentTab)
    );

  }

  void _initializeProfileData() async {

    try {

      if ((userProvider.user.socialHandles ?? {}).isEmpty) {

        await UserInfoService.getSocialHandles(username: userProvider.user.username).then(
          (socialHandles) => userProvider.setSocialHandles(socialHandles)
        );

      }

      await profilePostsSetup.setupOwnPosts();

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }

  Widget _buildPronouns() {
    return Selector<ProfileProvider, String>(
      selector: (_, profileData) => profileData.profile.pronouns,
      builder: (_, pronouns, __) {

        final bottomPadding = pronouns.isNotEmpty ? 11.0 : 0.0;
        final topPadding = pronouns.isNotEmpty ? 5.0 : 0.0;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.65,
            child: Text(
              pronouns,
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
      width: MediaQuery.sizeOf(context).width * 0.68,
      child: Consumer<ProfileProvider>(
        builder: (_, profileData, __) {
          return profileData.profile.bio.isEmpty
            ? Transform.translate(
              offset: Offset(0, profileData.profile.pronouns.isEmpty ? -5 : -2),
              child: Text(
                'No bio yet...',
                style: ThemeStyle.profileEmptyBioStyle,
                textAlign: TextAlign.start,
              ),
            )
            : Transform.translate(
              offset: Offset(0, profileData.profile.pronouns.isEmpty ? -5 : -2),
              child: GestureDetector(
              onTap: () => BottomsheetFullBio().buildBottomsheet(context: context, bio: profileData.profile.bio),
                child: Text(
                  profileData.profile.bio,
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

  Widget _popularityWidgets() {
    return Consumer<ProfileProvider>(
      builder: (_, profileData, __) {
        return Consumer<ProfilePostsProvider>(
          builder: (_, postsData, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                profileInfoWidgets.buildPopularityHeader('Vents', postsData.myProfile.titles.length),

                GestureDetector(
                  onTap: () => NavigatePage.followsPage(
                    pageType: 'Followers', 
                    username: userProvider.user.username,
                    totalFollowers: profileData.profile.followers,
                    totalFollowing: profileData.profile.following
                  ),
                  child: profileInfoWidgets.buildPopularityHeader('Followers', profileData.profile.followers)
                ),
          
                GestureDetector(
                  onTap: () => NavigatePage.followsPage(
                    pageType: 'Following', 
                    username: userProvider.user.username,
                    totalFollowers: profileData.profile.followers,
                    totalFollowing: profileData.profile.following
                  ),
                  child: profileInfoWidgets.buildPopularityHeader('Following', profileData.profile.following)
                ),
          
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSocialLinks() {
    return Selector<UserProvider, Map<String, String>?>(
      selector: (_, userData) => userData.user.socialHandles,
      builder: (_, socialHandles, __) {

        if ((socialHandles ?? {}).isEmpty) {
          return const SizedBox.shrink();
        }

        return SocialsWidget(
          socialHandles: socialHandles!
        ).buildSocialLinks();

      },
    );
  }

  Widget _buildEditProfileButton() {
    return Align(
      alignment: Alignment.center,
      child: CustomOutlinedButton(
        customWidth: MediaQuery.sizeOf(context).width * 0.87,
        customHeight: 45.0,
        customFontSize: 15.5,
        text: 'Edit Profile',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EditProfilePage()
            )
          );
        }
      ),
    );
  }

  Widget _buildBody() {
    return ProfileBodyWidgets(
      onRefresh: () async => await RefreshService().refreshMyProfile(),
      tabBarWidgets: tabBarWidgets, 
      profileInfoWidgets: profileInfoWidgets, 
      pronounsWidget: _buildPronouns(), 
      bioWidget: _buildBio(), 
      userActionButtonWidget: _buildEditProfileButton(), 
      popularityWidget: _popularityWidgets()
    );
  }

  Widget _buildSettingsActionButton() {
    return IconButton(
      icon: Icon(CupertinoIcons.bars, size: 28, color: ThemeColor.contentPrimary),
      onPressed: NavigatePage.settingsPage
    );
  }

  Widget _buildPrivacyLeadingButton() {
    return IconButton(
      icon: Icon(CupertinoIcons.lock, size: 24, color: ThemeColor.contentPrimary),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PrivacyPage()
          )
        );
      }
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
    navigationProvider.setProfileTab(ProfileTabs.posts);
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
          actions: [
            _buildSocialLinks(),
            _buildSettingsActionButton()
          ]
        ).buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: NavigationBarDock()
      ),
    );
  }
  
}