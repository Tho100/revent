import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_query/user_profile/profile_data_update.dart';
import 'package:revent/model/profile_picture_model.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/alert_dialog.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/main_button.dart';
import 'package:revent/widgets/profile_picture.dart';
import 'package:revent/widgets/text_field/main_textfield.dart';

class EditProfilePage extends StatefulWidget {

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => EditProfilePageState();
  
}

class EditProfilePageState extends State<EditProfilePage> {

  final profileData = GetIt.instance<ProfileDataProvider>();

  final bioController = TextEditingController();
  final pronounOneController = TextEditingController();
  final pronounTwoController = TextEditingController();

  final headerTextDefaultStyle = GoogleFonts.inter(
    color: ThemeColor.thirdWhite,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  final profilePicNotifier = ValueNotifier<Uint8List>(Uint8List(0));

  bool isBioChanges = false;
  bool isPronounsChanges = false;

  void _setTextFieldsListeners() {

    bioController.addListener(() {
      isBioChanges = true;
    });

    pronounOneController.addListener(() {
      isPronounsChanges = true;
    });

    pronounTwoController.addListener(() {
      isPronounsChanges = true;
    });

  }

  void _setProfilePic() {
    profilePicNotifier.value = profileData.profilePicture;
  }

  void _setBioText() {
    bioController.text = profileData.bio;
  }

  void _setPronouns() {

    if(profileData.pronouns.isNotEmpty) {
      
      final splittedPronouns = profileData.pronouns.split('/');

      pronounOneController.text = splittedPronouns[0];
      pronounTwoController.text = splittedPronouns[1];

    }

  }

  void _saveChangesOnPressed() async {

    bool isSaved = true;

    if (isBioChanges) {
      if (await _saveBio() == false) {
        isSaved = false; 
      }
    }

    if (isPronounsChanges) {
      if (await _savePronouns() == false) {
        isSaved = false; 
      }
    }

    if (isSaved) {
      SnackBarDialog.temporarySnack(message: 'Saved changes.');
    }

  }

  void _changeProfilePicOnPressed() async {
    
    final isProfileSelected = await ProfilePictureModel()
      .createProfilePicture(context);

    if(isProfileSelected) {
      _setProfilePic();
      SnackBarDialog.temporarySnack(message: 'Profile picture has been updated.');
    }

  }

  Future<bool> _saveBio() async {

    try {

      await ProfileDataUpdate()
        .updateBio(bioText: bioController.text);

      return true;

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to save changes.');
      return false;
    }

  }

  Future<bool> _savePronouns() async {

    try {

      final isBothEmpty = pronounOneController.text.isEmpty && pronounTwoController.text.isEmpty;
      final isBothFilled = pronounOneController.text.isNotEmpty && pronounTwoController.text.isNotEmpty;

      if (!isBothEmpty && !isBothFilled) {
        CustomAlertDialog.alertDialog('Both fields must be filled or left empty');
        return false; 
      }

      final concatenatedPronouns = isBothEmpty 
        ? '' 
        : "${pronounOneController.text}/${pronounTwoController.text}";

      await ProfileDataUpdate().updatePronouns(pronouns: concatenatedPronouns);

      return true;

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to save changes.');
      return false;
    }

  }

  Widget _buildProfilePicture(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ProfilePictureWidget(
          customWidth: 80,
          customHeight: 80,
          profileDataNotifier: profilePicNotifier,
        ),

        const SizedBox(height: 20),

        MainButton(
          customWidth: MediaQuery.of(context).size.width * 0.55,
          customHeight: 46,
          customFontSize: 15,
          text: 'Change profile picture', 
          onPressed: () => _changeProfilePicOnPressed()
        ),

      ],
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
        
          ],
        ),
      ),
    );
  }

  Widget _buildPronouns(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Text(
              'My pronouns',
              style: headerTextDefaultStyle,
            ),
        
            const SizedBox(height: 16),
        
            Row(
              children: [

                Flexible(
                  child: MainTextField(
                    controller: pronounOneController, 
                    hintText: '',
                    maxLines: 1,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')), // TODO: use disablewhitesapce class
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  '/',
                  style: GoogleFonts.inter(
                    color: ThemeColor.secondaryWhite,
                    fontWeight: FontWeight.w800,
                    fontSize: 18
                  ),
                ),
                
                const SizedBox(width: 8),
              
                Flexible(
                  child: MainTextField(
                    controller: pronounTwoController, 
                    hintText: '',
                    maxLines: 1,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height: 12),
        
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon: const Icon(Icons.check, size: 22),
        onPressed: () => _saveChangesOnPressed(),
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
                
            _buildPronouns(context),
              
            const SizedBox(height: 40),
      
            _buildBio(context),
      
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _setProfilePic();
    _setBioText();
    _setPronouns();
    _setTextFieldsListeners();
  }

  @override
  void dispose() {
    profilePicNotifier.dispose();
    bioController.dispose();
    pronounOneController.dispose();
    pronounTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      appBar: CustomAppBar(
        context: context,
        title: 'Edit profile',
        actions: [_buildActionButton()]
      ).buildAppBar(),
    );
  }

}