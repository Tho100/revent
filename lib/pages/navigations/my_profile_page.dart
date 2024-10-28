import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:revent/data_query/user_profile/profile_data_setup.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/edit_profile_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/themes/theme_style.dart';
import 'package:revent/ui_dialog/profile_picture_dialog.dart';
import 'package:revent/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

class MyProfilePage extends StatefulWidget {

  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => MyProfilePageState();

}

class MyProfilePageState extends State<MyProfilePage> {

  final navigationIndex = GetIt.instance<NavigationProvider>();
  final userData = GetIt.instance<UserDataProvider>();
  final profileData = GetIt.instance<ProfileDataProvider>();

  Future<void> _pageOnRefresh() async {

    profileData.clearProfileData();

    await ProfileDataSetup().setup(username: userData.user.username);

  }

  Widget _buildUsername() {
    return Text(
      userData.user.username,
      style: ThemeStyle.profileUsernameStyle
    );
  }

  Widget _buildPronouns(BuildContext context) {
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

  Widget _buildBio(BuildContext context) {
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

  Widget _buildEditProfileButton(BuildContext context) {
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

  Widget _buildPopularityHeader(String header, int value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          value.toString(),
          style: GoogleFonts.inter(
            color: ThemeColor.white,
            fontWeight: FontWeight.w800,
            fontSize: 20
          ),
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
                child: _buildPopularityHeader('followers', profileData.followers)
              ),

              _buildPopularityHeader('vents', profileData.posts),

              GestureDetector(
                onTap: () => NavigatePage.followsPage(pageType: 'Following', username: userData.user.username),
                child: _buildPopularityHeader('following', profileData.following)
              ),

            ],
          );
        },
      ),
    );
  }

  Widget _buildProfilePicture() {
    return InkWellEffect(
      onPressed: () => ProfilePictureDialog().showPfpDialog(context, profileData.profilePicture),
      child: ProfilePictureWidget(
        customHeight: 75,
        customWidth: 75,
        pfpData: profileData.profilePicture,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Column(
        children: [

          const SizedBox(height: 27),

          _buildProfilePicture(),
          
          const SizedBox(height: 12),

          _buildUsername(),

          _buildPronouns(context),

          _buildBio(context),
    
          const SizedBox(height: 25),

          _buildEditProfileButton(context),

          const SizedBox(height: 40),

          _popularityWidgets(),

        ],
      ),
    );
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
          onRefresh: () async => await _pageOnRefresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _buildBody(context)
          ),
        ),
        bottomNavigationBar: UpdateNavigation(
          context: context,
        ).showNavigationBar(),
      ),
    );
  }
  
}