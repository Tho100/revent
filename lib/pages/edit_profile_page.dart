import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_query/profile_data_update.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/main_button.dart';
import 'package:revent/widgets/profile_picture.dart';
import 'package:revent/widgets/text_field/main_textfield.dart';

class EditProfilePage extends StatelessWidget {

  EditProfilePage({super.key});

  final userData = GetIt.instance<UserDataProvider>();

  final bioController = TextEditingController();

  final headerTextDefaultStyle = GoogleFonts.inter(
    color: ThemeColor.thirdWhite,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  Widget _buildProfilePicture(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const ProfilePictureWidget(
          customWidth: 80,
          customHeight: 80,
        ),

        const SizedBox(height: 20),

        MainButton(
          customWidth: MediaQuery.of(context).size.width * 0.44,
          customHeight: 46,
          customFontSize: 15,
          text: 'Change profile picture', 
          onPressed: () => print('hi'),
        ),

      ],
    );
  }

  Widget _buildHeaders(String header, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(
            header,
            style: headerTextDefaultStyle,
          ),
    
          const SizedBox(height: 8),
    
          Text(
            value,
            style: GoogleFonts.inter(
              color: ThemeColor.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
    
          const SizedBox(height: 20),
    
        ],
      ),
    );
  }

  Widget _buildUpgradeButton(BuildContext context) {
    return MainButton(
      customWidth: MediaQuery.of(context).size.width * 0.24,
      customHeight: 46,
      customFontSize: 15,
      text: 'Upgrade', 
      onPressed: () => print('Upgrade')
    );
  }

  Widget _buildBio(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Text(
              'Bio',
              style: headerTextDefaultStyle,
            ),
        
            const SizedBox(height: 16),
        
            MainTextField(
              controller: bioController, 
              hintText: 'Enter your bio here...',
              maxLines: 5,
              maxLength: 100,
            ),
            
            const SizedBox(height: 12),
        
            Align(
              alignment: Alignment.bottomRight,
              child: MainButton(
                customWidth: MediaQuery.of(context).size.width * 0.24,
                customHeight: 46,
                customFontSize: 15,
                text: 'Save', 
                onPressed: () async {
                  await ProfileDataUpdate(username: userData.username)
                    .updateBio(bioText: bioController.text);
                }
              ),
            ),
        
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _buildProfilePicture(context),
      
            const SizedBox(height: 42),
      
            _buildHeaders('Username', userData.username),
            _buildHeaders('Email', userData.email),
            _buildHeaders('Plan', userData.plan),
      
            _buildUpgradeButton(context), 
      
            const SizedBox(height: 40),
      
            _buildBio(context),
      
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      appBar: CustomAppBar(
        title: 'Edit profile',
        context: context
      ).buildAppBar(),
    );
  }

}