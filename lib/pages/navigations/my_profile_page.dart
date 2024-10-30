import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revent/helper/call_refresh.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/edit_profile_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/widgets/buttons/custom_outlined_button.dart';
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

  late ProfileInfoWidgets profileInfoWidgets;
  late ProfileTabBarWidgets tabBarWidgets;
  late TabController tabController;

  Widget _buildPronouns() {
    return Consumer<ProfileDataProvider>(
      builder: (_, profileData, __) {
        final bottomPadding = profileData.pronouns.isNotEmpty ? 14.0 : 0.0;
        final topPadding = profileData.pronouns.isNotEmpty ? 8.0 : 0.0;
          return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Text(
              profileData.pronouns,
              style: ThemeStyle.profilePronounsStyle,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBio() {
    return Consumer<ProfileDataProvider>(
      builder: (_, profileData, __) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: Text(
            profileData.bio,
            style: ThemeStyle.profileBioStyle,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        );
      },
    );
  }

  Widget _buildEditProfileButton() {
    return Align(
      alignment: Alignment.center,
      child: CustomOutlinedButton(
        customWidth: MediaQuery.of(context).size.width * 0.45,
        customHeight: MediaQuery.of(context).size.height * 0.050,
        customFontSize: 15.5,
        text: 'Edit profile',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditProfilePage())
        )
      ),
    );
  }

  Widget _popularityWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Consumer<ProfileDataProvider>(
        builder: (_, profileData, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              
              GestureDetector(
                onTap: () => NavigatePage.followsPage(pageType: 'Followers', username: userData.user.username),
                child: profileInfoWidgets.buildPopularityHeader('followers', profileData.followers)
              ),

              profileInfoWidgets.buildPopularityHeader('vents', profileData.posts),

              GestureDetector(
                onTap: () => NavigatePage.followsPage(pageType: 'Following', username: userData.user.username),
                child: profileInfoWidgets.buildPopularityHeader('following', profileData.following)
              ),

            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Column(
          children: [

            const SizedBox(height: 27),

            profileInfoWidgets.buildProfilePicture(),
            
            const SizedBox(height: 12),

            profileInfoWidgets.buildUsername(),

            _buildPronouns(),

            _buildBio(),
      
            const SizedBox(height: 25),

            _buildEditProfileButton(),

            const SizedBox(height: 28),

            _popularityWidgets(),

            tabBarWidgets.buildTabBar(),

            tabBarWidgets.buildTabBarTabs(),

          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    navigationIndex.setPageIndex(0);
    profileInfoWidgets = ProfileInfoWidgets(context: context, username: userData.user.username, pfpData: profileData.profilePicture);
    tabController = TabController(length: 2, vsync: this);
    tabBarWidgets = ProfileTabBarWidgets(context: context, controller: tabController);
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
        body: RefreshIndicator(
          color: ThemeColor.mediumBlack,
          onRefresh: () async => await CallRefresh().refreshProfile(),
          child: _buildBody()
        ),
        bottomNavigationBar: UpdateNavigation(
          context: context,
        ).showNavigationBar(),
      ),
    );
  }
  
}