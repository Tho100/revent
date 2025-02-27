import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/user/user_socials.dart';
import 'package:revent/service/query/user_profile/profile_data_update.dart';
import 'package:revent/helper/textinput_formatter.dart';
import 'package:revent/model/profile_picture/profile_picture_model.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/text_field/main_textfield.dart';

class EditProfilePage extends StatefulWidget {

  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
  
}

class _EditProfilePageState extends State<EditProfilePage> with UserProfileProviderService {

  final bioController = TextEditingController();
  final pronounOneController = TextEditingController();
  final pronounTwoController = TextEditingController();

  final instagramController = TextEditingController();
  final twitterController = TextEditingController();
  final tiktokController = TextEditingController();

  final profilePicNotifier = ValueNotifier<Uint8List>(Uint8List(0));
  final pronounsSelectedNotifier = ValueNotifier<List<bool>>([]);

  List<String> pronounsChips = [];

  bool isBioChanges = false;
  bool isPronounsChanges = false;
  bool isSocialChanges = false;

  void _enforceBioMaxLines() {

    final text = bioController.text;

    final lines = text.split('\n');

    if (lines.length > 4) {
      bioController.text = lines.take(4).join('\n');
      bioController.selection = TextSelection.fromPosition(
        TextPosition(offset: bioController.text.length),
      );
    }

  }

  void _initializeTextFieldsListeners() {

    bioController.addListener(
      () => isBioChanges = true
    );

    for (var pronounController in [pronounOneController, pronounTwoController]) {
      pronounController.addListener(
        () => isPronounsChanges = true
      );
    }

    for (var socialsController in [instagramController, twitterController, tiktokController]) {
      socialsController.addListener(
        () => isPronounsChanges = true
      );
    }

  }

  void _initializePronounsChips() {
    
    pronounsChips = [
      'he/him', 
      'she/her',
      'they/them',
    ];

    final currentPronouns = '${pronounOneController.text}/${pronounTwoController.text}';

    pronounsSelectedNotifier.value = List<bool>.generate(pronounsChips.length, 
      (index) => pronounsChips[index] == currentPronouns ? true : false
    );

  }

  void _initializeProfileData() {

    profilePicNotifier.value = profileProvider.profile.profilePicture;

    bioController.text = profileProvider.profile.bio;
    bioController.addListener(_enforceBioMaxLines);

    if(profileProvider.profile.pronouns.isNotEmpty) {
      
      final splittedPronouns = profileProvider.profile.pronouns.split('/');

      pronounOneController.text = splittedPronouns[0];
      pronounTwoController.text = splittedPronouns[1];

    }

  }

  void _saveChangesOnPressed() async {

    bool isSaved = true;

    if (isBioChanges) {
      if (!await _saveBio()) {
        isSaved = false; 
      }
    }

    if (isPronounsChanges) {
      if (!await _savePronouns()) {
        isSaved = false; 
      }
    }

    if (isSocialChanges) {
      if(!await _saveSocialLinks()) {
        isSaved = false;
      }
    }

    if (isSaved) {
      SnackBarDialog.temporarySnack(message: AlertMessages.savedChanges);
    }

  }

  void _changeProfilePicOnPressed() async {
    
    final isProfileSelected = await ProfilePictureModel().createProfilePicture(context);

    if(isProfileSelected) {
      profilePicNotifier.value = profileProvider.profile.profilePicture;
      SnackBarDialog.temporarySnack(message: 'Profile picture has been updated.');
    }

  }

  Future<bool> _saveSocialLinks() async {

    try {

      final socialLinks = {
        'instagram': instagramController.text,
        'twitter': twitterController.text,
        'tiktok': tiktokController.text,
      };

      for (final entry in socialLinks.entries) {

        final platform = entry.key;
        final handle = entry.value;

        if (handle.isNotEmpty) {
          await UserSocials().addSocial(platform: platform, handle: handle);
        }

      }

      return true;

    } catch (_) {
      return false;
    }

  }

  Future<bool> _saveBio() async {

    try {

      await ProfileDataUpdate().updateBio(bioText: bioController.text);

      return true;

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.changesFailed);
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
        : '${pronounOneController.text}/${pronounTwoController.text}';

      await ProfileDataUpdate().updatePronouns(pronouns: concatenatedPronouns);

      return true;

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.changesFailed);
      return false;
    }

  }

  void _pronounsChipsOnSelected(String pronouns) {

    if(pronouns.isEmpty) {
      pronounOneController.text = '';
      pronounTwoController.text = '';
      return;
    }

    final splittedPronouns = pronouns.split('/'); 

    pronounOneController.text = splittedPronouns[0];
    pronounTwoController.text = splittedPronouns[1];

  }

  Widget _buildProfilePicture() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: InkWellEffect(
        onPressed: () => _changeProfilePicOnPressed(),
        child: SizedBox(
          width: 88,
          height: 88,
          child: Stack(
            children: [
        
              ValueListenableBuilder(
                valueListenable: profilePicNotifier,
                builder: (_, pfp, __) {
                  return ProfilePictureWidget(
                    customWidth: 85,
                    customHeight: 85,
                    customEmptyPfpSize: 30,
                    pfpData: pfp,
                  );
                }
              ),
        
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeColor.white,
                      borderRadius: BorderRadius.circular(360)
                    ),
                    child: const Icon(CupertinoIcons.camera, color: ThemeColor.mediumBlack, size: 16),
                  ),
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPronounsChip(String pronouns, int index) {
    return ValueListenableBuilder(
      valueListenable: pronounsSelectedNotifier,
      builder: (_, chipSelected, __) {
        return ChoiceChip(
          label: Text(
            pronouns,
            style: GoogleFonts.inter(
              color: chipSelected[index] ?ThemeColor.mediumBlack : ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w700,
              fontSize: 14
            )
          ),
          selected: chipSelected[index],
          onSelected: (bool selected) {

            if (selected) {
              pronounsSelectedNotifier.value = List.generate(chipSelected.length, (i) => i == index);
              _pronounsChipsOnSelected(pronouns);

            } else {
              pronounsSelectedNotifier.value[index] = false;
              pronounsSelectedNotifier.value = List.from(chipSelected);
              _pronounsChipsOnSelected('');

            }

          },
          selectedColor: ThemeColor.white,
          backgroundColor: ThemeColor.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: chipSelected[index] ? ThemeColor.black : ThemeColor.thirdWhite, 
              width: 1,
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildPronounsChoiceChips() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.88,
        child: Wrap(
          spacing: 10.0, 
          children: [
            for(int i=0; i<pronounsSelectedNotifier.value.length; i++) ... [
              _buildPronounsChip(pronounsChips[i], i),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildProfileEditingWidget({
    required String header, 
    required List<Widget> children
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              header,
              style: GoogleFonts.inter(
                color: ThemeColor.thirdWhite,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ), 

            const SizedBox(height: 16),

            ...children

          ],
        )
      )
    );
  }

  Widget _buildPronouns() {
    return _buildProfileEditingWidget(
      header: 'My pronouns', 
      children: [
        
        Row(
          children: [

            Flexible(
              child: MainTextField(
                controller: pronounOneController, 
                hintText: '',
                maxLines: 1,
                maxLength: 10,
                inputFormatters: TextInputFormatterModel().onlyAllowLetters()
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
                inputFormatters: TextInputFormatterModel().onlyAllowLetters()
              ),
            ),

          ],
        ),

        const SizedBox(height: 14),

        _buildPronounsChoiceChips(),

        const SizedBox(height: 12),

      ]
    );
  }

  Widget _buildBio() {
    return _buildProfileEditingWidget(
      header: 'Bio',
      children: [
        
        MainTextField(
          controller: bioController, 
          hintText: 'Enter your bio here...',
          maxLines: 6,
          maxLength: 245,
        ),
        
        const SizedBox(height: 8),

      ]
    );
  }

  Widget _buildSocialHeader(String platform, TextEditingController controller) {
    return Column(
      children: [

        Container(
          height: 25,
          decoration: BoxDecoration(
            color: ThemeColor.black,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ThemeColor.thirdWhite
            )
          ),
          child: Row(
            children: [

              Icon(Icons.abc),

              const SizedBox(width: 6),

              Text(
                platform,
                style: GoogleFonts.inter(
                  color: ThemeColor.secondaryWhite,
                  fontWeight: FontWeight.w800,
                  fontSize: 12
                ),
              )

            ],
          ),
        ),

        MainTextField(
          controller: controller,
          maxLines: 1,
        ),

        const SizedBox(height: 8),

      ],
    );
  }

  Widget _buildSocialLinks() {
    return _buildProfileEditingWidget(
      header: 'Social Links', 
      children: [

      _buildSocialHeader(
        'Instagram',
        instagramController
      ),

      _buildSocialHeader(
        'Twitter',
        twitterController
      ),

      _buildSocialHeader(
        'TikTok',
        tiktokController
      ),

      ]
    );
  }

  Widget _buildActionButton() {
    return IconButton(
      icon: const Icon(Icons.check, size: 22),
      onPressed: () => _saveChangesOnPressed(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _buildProfilePicture(),
      
            const SizedBox(height: 40),
                
            _buildPronouns(),
              
            const SizedBox(height: 30),
      
            _buildBio(),
      
            const SizedBox(height: 20),

            _buildSocialLinks(),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeProfileData();
    _initializeTextFieldsListeners();
    _initializePronounsChips();
  }

  @override
  void dispose() {
    profilePicNotifier.dispose();
    bioController.dispose();
    pronounOneController.dispose();
    pronounTwoController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    tiktokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: 'Edit profile',
        actions: [_buildActionButton()]
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}