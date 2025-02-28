import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/global/profile_type.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/model/setup/profile_posts_setup.dart';
import 'package:revent/service/refresh_service.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/profile/edit_profile_page.dart';
import 'package:revent/pages/setttings/privacy_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/bottomsheet/user/view_full_bio.dart';
import 'package:revent/shared/widgets/navigation/page_navigation_bar.dart';
import 'package:revent/shared/provider/profile/profile_provider.dart';
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

class _MyProfilePageState extends State<MyProfilePage> with 
  SingleTickerProviderStateMixin, 
  UserProfileProviderService,
  NavigationProviderService {

  late ProfilePostsSetup callProfilePosts;
  late ProfileInfoWidgets profileInfoWidgets;
  late ProfileTabBarWidgets tabBarWidgets;
  late TabController tabController;

  void _initializeClasses() {

    callProfilePosts = ProfilePostsSetup(
      profileType: ProfileType.myProfile.value,
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

    if(tabController.index == 1) {
      await callProfilePosts.setupSaved();
    }

    setState(() {
      navigationProvider.setProfileTabIndex(tabController.index);
    });

  }

  void _initializePostsData() async {

    try {

      await callProfilePosts.setupPosts();

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
    }

  }

  Widget _buildPronouns() {
    return Consumer<ProfileProvider>(
      builder: (_, profileData, __) {
        final bottomPadding = profileData.profile.pronouns.isNotEmpty ? 11.0 : 0.0;
        final topPadding = profileData.profile.pronouns.isNotEmpty ? 5.0 : 0.0;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text(
              profileData.profile.pronouns,
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
      child: Consumer<ProfileProvider>(
        builder: (_, profileData, __) {
          return profileData.profile.bio.isEmpty
            ? Transform.translate(
              offset: Offset(0, profileData.profile.pronouns.isEmpty ? -5 : -2),
              child: const Text(
                'No bio yet...',
                style: ThemeStyle.profileEmptyBioStyle,
                textAlign: TextAlign.start,
              ),
            )
            : Transform.translate(
              offset: Offset(0, profileData.profile.pronouns.isEmpty ? -5 : -2),
              child: GestureDetector(
              onTap: () => BottomsheetViewFullBio().buildBottomsheet(context: context, bio: profileData.profile.bio),
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
    return Consumer<ProfileProvider>(
      builder: (_, profileData, __) {
        return Consumer<ProfilePostsProvider>(
          builder: (_, postsData, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                profileInfoWidgets.buildPopularityHeader('vents', postsData.myProfile.titles.length),

                GestureDetector(
                  onTap: () => NavigatePage.followsPage(pageType: 'Followers', username: userProvider.user.username),
                  child: profileInfoWidgets.buildPopularityHeader('followers', profileData.profile.followers)
                ),
          
                GestureDetector(
                  onTap: () => NavigatePage.followsPage(pageType: 'Following', username: userProvider.user.username),
                  child: profileInfoWidgets.buildPopularityHeader('following', profileData.profile.following)
                ),
          
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return Consumer<ProfileProvider>(
      builder: (_, profileData, __) {
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

  Widget _buildSocialLinksIcon(String platform, String handle, IconData icon, double customSize) {

    final url = {
      'instagram': 'instagram.com/$handle',
      'twitter': 'twitter.com/$handle',
      'tiktok': 'tiktok.com/$handle',
    };

    return Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 2.0),
      child: GestureDetector(
        onTap: () {},
        child: FaIcon(icon, color: ThemeColor.white, size: customSize),
      ),
    );

  }

  Widget _buildSocialLinks() {
    return Row(
      children: [

        if(userProvider.user.socialHandles['tiktok']!.isNotEmpty)
        _buildSocialLinksIcon(
          'tiktok', 
          userProvider.user.socialHandles['tiktok']!,
          FontAwesomeIcons.tiktok, 19
        ),

        if(userProvider.user.socialHandles['twitter']!.isNotEmpty)
        _buildSocialLinksIcon(
          'twitter', 
          userProvider.user.socialHandles['twitter']!,
          FontAwesomeIcons.twitter, 21
        ),

        if(userProvider.user.socialHandles['instagram']!.isNotEmpty)
        _buildSocialLinksIcon(
          'instagram', 
          userProvider.user.socialHandles['instagram']!, 
          FontAwesomeIcons.instagram, 22
        ),

      ],
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
    navigationProvider.setProfileTabIndex(0);
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
          actions: [_buildSocialLinks(), _buildSettingsActionButton()]
        ).buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: PageNavigationBar()
      ),
    );
  }
  
}