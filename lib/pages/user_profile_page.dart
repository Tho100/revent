import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_query/user_actions.dart';
import 'package:revent/data_query/user_following.dart';
import 'package:revent/data_query/user_profile/profile_data_getter.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/custom_outlined_button.dart';
import 'package:revent/widgets/buttons/main_button.dart';
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

class UserProfilePageState extends State<UserProfilePage> {

  final navigationIndex = GetIt.instance<NavigationProvider>();
  final userData = GetIt.instance<UserDataProvider>();
  final profileData = GetIt.instance<ProfileDataProvider>();

  final followersNotifier = ValueNotifier<int>(0);
  final followingNotifier = ValueNotifier<int>(0);
  final postsNotifier = ValueNotifier<int>(0);
  final bioNotifier = ValueNotifier<String>('');

  final isFollowingNotifier = ValueNotifier<bool>(false);

  Future<void> _setProfileData() async {

    final getProfileData = await ProfileDataGetter()
      .getProfileData(isMyProfile: false, username: widget.username);
    
    postsNotifier.value = getProfileData['posts'];
    followersNotifier.value = getProfileData['followers']; 
    followingNotifier.value = getProfileData['following'];
    bioNotifier.value =  getProfileData['bio'];

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
      style: GoogleFonts.inter(
        color: ThemeColor.white,
        fontWeight: FontWeight.w800,
        fontSize: 20.5
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: ValueListenableBuilder(
        valueListenable: bioNotifier,
        builder: (context, value, widget) {
          return Text(
            value,
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w700,
              fontSize: 14
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
          );
        },
      ),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ValueListenableBuilder(
        valueListenable: isFollowingNotifier,
        builder: (context, isFollowing, child) {
          return isFollowing 
            ? CustomOutlinedButton(
              customWidth: MediaQuery.of(context).size.width * 0.45,
              customHeight: MediaQuery.of(context).size.height * 0.050,
              customFontSize: 15.5,
              text: 'Following',
              onPressed: () => _followUserOnPressed()
            )
            : MainButton(
              customWidth: MediaQuery.of(context).size.width * 0.45,
              customHeight: MediaQuery.of(context).size.height * 0.050,
              customFontSize: 15.5,
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
          builder: (context, value, child) {
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
    
          _buildPopularityHeader('followers', followersNotifier),
          _buildPopularityHeader('posts', postsNotifier),
          _buildPopularityHeader('following', followingNotifier),
    
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
        children: [
  
        ProfilePictureWidget(
          pfpData: widget.pfpData,
        ),
        
        const SizedBox(height: 12),
  
        _buildUsername(),
  
        const SizedBox(height: 8),
  
        _buildBio(context),
  
        const SizedBox(height: 25),
  
        _buildEditProfileButton(context),

        const SizedBox(height: 40),

        _popularityWidgets(context),

      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _setProfileData();
  }

  @override
  void dispose() {
    super.initState();
    followersNotifier.dispose();
    followingNotifier.dispose();
    postsNotifier.dispose();
    bioNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: ''
      ).buildAppBar(),
      body: RefreshIndicator(
        color: ThemeColor.mediumBlack,
        onRefresh: () async => await _setProfileData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: _buildBody(context)
        ),
      ),
      bottomNavigationBar: UpdateNavigation(
        context: context,
      ).showNavigationBar(),
    );
  }
  
}