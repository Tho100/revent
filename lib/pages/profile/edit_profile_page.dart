import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/user/user_socials.dart';
import 'package:revent/service/query/user_profile/profile_data_update.dart';
import 'package:revent/helper/input_formatters.dart';
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

  final pronounControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  final socialControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final profilePicNotifier = ValueNotifier<Uint8List>(Uint8List(0));
  final pronounsSelectedNotifier = ValueNotifier<List<bool>>([]);

  final isSavedNotifier = ValueNotifier<bool>(true);

  List<String> pronounsChips = [];

  bool isBioChanges = false;
  bool isPronounsChanges = false;
  bool isSocialChanges = false;

  void _disposeControllers() {

    bioController.dispose();

    for (var pronouns in pronounControllers) {
      pronouns.dispose();
    }

    for (var socials in socialControllers) {
      socials.dispose();
    }

  }

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

    bioController.addListener(() {
      isBioChanges = true;
      isSavedNotifier.value = false;
    });

    for (var pronounsController in pronounControllers) {
      pronounsController.addListener(() {
        isPronounsChanges = true;
        isSavedNotifier.value = false;
      });
    }

    for (var socialsController in socialControllers) {
      socialsController.addListener(() {
        isSocialChanges = true;
        isSavedNotifier.value = false;
      });
    }

  }

  void _initializeSocialHandles() async {

    final socialHandles = userProvider.user.socialHandles;

    final controllers = {
      'instagram': socialControllers[0],
      'twitter': socialControllers[1],
      'tiktok': socialControllers[2],
    };

    controllers.forEach((platform, controller) {
      controller.text = socialHandles[platform] ?? '';
    });

  }

  void _initializePronounsChips() {
    
    pronounsChips = [
      'he/him', 
      'she/her',
      'they/them',
    ];

    final currentPronouns = '${pronounControllers[0].text}/${pronounControllers[1].text}';

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

      pronounControllers[0].text = splittedPronouns[0];
      pronounControllers[1].text = splittedPronouns[1];

    }

  }

  void _saveChangesOnPressed() async {

    if (isBioChanges) {
      if (!await _saveBio()) {
        isSavedNotifier.value = false; 
      }
    }

    if (isPronounsChanges) {
      if (!await _savePronouns()) {
        isSavedNotifier.value = false; 
      }
    }

    if (isSocialChanges) {
      if(!await _saveSocialLinks()) {
        isSavedNotifier.value = false;
      }
    }

    if (isSavedNotifier.value) {
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
        'instagram': socialControllers[0].text,
        'twitter': socialControllers[1].text,
        'tiktok': socialControllers[2].text,
      };

      for (final entry in socialLinks.entries) {

        final platform = entry.key;
        final handle = entry.value;

        if (handle.isNotEmpty) {
          await UserSocials(platform: platform, handle: handle).addSocial();
        }

      }

      userProvider.user.socialHandles = socialLinks;

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

      final isBothEmpty = pronounControllers[0].text.isEmpty && pronounControllers[1].text.isEmpty;
      final isBothFilled = pronounControllers[0].text.isNotEmpty && pronounControllers[1].text.isNotEmpty;

      if (!isBothEmpty && !isBothFilled) {
        CustomAlertDialog.alertDialog('Both fields must be filled or left empty');
        return false; 
      }

      final concatenatedPronouns = isBothEmpty 
        ? '' 
        : '${pronounControllers[0].text}/${pronounControllers[1].text}';

      await ProfileDataUpdate().updatePronouns(pronouns: concatenatedPronouns);

      return true;

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.changesFailed);
      return false;
    }

  }

  void _pronounsChipsOnSelected(String pronouns) {

    if(pronouns.isEmpty) {
      pronounControllers[0].text = '';
      pronounControllers[1].text = '';
      return;
    }

    final splittedPronouns = pronouns.split('/'); 

    pronounControllers[0].text = splittedPronouns[0];
    pronounControllers[1].text = splittedPronouns[1];

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
                    child: const Icon(CupertinoIcons.pencil, color: ThemeColor.mediumBlack, size: 18.5),
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
                controller: pronounControllers[0], 
                hintText: '',
                maxLines: 1,
                maxLength: 10,
                inputFormatters: InputFormatters().onlyLetters()
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
                controller: pronounControllers[1], 
                hintText: '',
                maxLines: 1,
                maxLength: 10,
                inputFormatters: InputFormatters().onlyLetters()
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

  Widget _buildSocialHeader(String platform, IconData platformIcon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          height: 36,
          width: 130,
          decoration: BoxDecoration(
            color: ThemeColor.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ThemeColor.thirdWhite
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              FaIcon(platformIcon, color: ThemeColor.white, size: 16), 

              const SizedBox(width: 6),

              Text(
                platform,
                style: GoogleFonts.inter(
                  color: ThemeColor.secondaryWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 14
                ),
              )

            ],
          ),
        ),

        const SizedBox(height: 12),

        MainTextField(
          controller: controller,
          hintText: 'Username',
          textInputAction: TextInputAction.next,
          maxLines: 1
        ),

        const SizedBox(height: 30),

      ],
    );
  }

  Widget _buildSocialLinks() {
    return _buildProfileEditingWidget(
      header: 'Social Links', 
      children: [

        const SizedBox(height: 10),

        _buildSocialHeader(
          'Instagram',
          FontAwesomeIcons.instagram,
          socialControllers[0]
        ),

        _buildSocialHeader(
          'Twitter',
          FontAwesomeIcons.twitter,
          socialControllers[1]
        ),

        _buildSocialHeader(
          'TikTok',
          FontAwesomeIcons.tiktok,
          socialControllers[2]
        ),

      ]
    );
  }

  Widget _buildSaveChangesButton() { 
    return ValueListenableBuilder(
      valueListenable: isSavedNotifier,
      builder: (_, isSaved, __) {
        return IconButton(
          icon: Icon(Icons.check, size: 22, color: isSaved ? ThemeColor.thirdWhite : ThemeColor.white),
          onPressed: () => isSaved ? null :  _saveChangesOnPressed(),
        );
      }
    );
  }

  Widget _buildBody() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
      child: SingleChildScrollView(
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
        
              const SizedBox(height: 30),

              _buildSocialLinks(),

              const SizedBox(height: 20),

            ],
          ),
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
    _initializeSocialHandles();
  }

  @override
  void dispose() {
    profilePicNotifier.dispose();
    isSavedNotifier.dispose();
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: 'Edit profile',
        actions: [_buildSaveChangesButton()]
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}