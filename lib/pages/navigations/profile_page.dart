import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/buttons/custom_outlined_button.dart';

class ProfilePage extends StatelessWidget {

  ProfilePage({super.key});

  final navigationIndex = GetIt.instance<NavigationProvider>();
  final userData = GetIt.instance<UserDataProvider>();

  Widget _buildProfilePicture() {
    return Container(
      width: 65,
      height: 65,
      decoration: const BoxDecoration(
        color: ThemeColor.white,
        shape: BoxShape.circle
      ),
    );
  }

  Widget _buildUsername() {
    return Text(
      userData.username,
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
      child: Text(
        'Livin the life innit my guy yeah',
        style: GoogleFonts.inter(
          color: ThemeColor.secondaryWhite,
          fontWeight: FontWeight.w700,
          fontSize: 14
        ),
        textAlign: TextAlign.center,
        maxLines: 3,
      ),
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
        onPressed: () => print('Edit profile'),
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

  Widget _popularityWidgets(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
    
          _buildPopularityHeader('followers', 10),
          _buildPopularityHeader('posts', 5),
          _buildPopularityHeader('following', 12),
    
        ],
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
    
          const SizedBox(height: 8),
    
          _buildBio(context),
    
          const SizedBox(height: 25),
    
          _buildEditProfileButton(context),

          const SizedBox(height: 40),

          _popularityWidgets(context),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    navigationIndex.setPageIndex(4);
    return WillPopScope(
      onWillPop: () async {
        NavigatePage.homePage(context);
        return true;
      },
      child: Scaffold(
        body: _buildBody(context),
        bottomNavigationBar: UpdateNavigation(
          context: context,
        ).showNavigationBar(),
      ),
    );
  }

}