import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/model/country_picker_model.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/user/user_socials.dart';
import 'package:revent/service/query/user_profile/profile_data_update.dart';
import 'package:revent/helper/input_formatters.dart';
import 'package:revent/model/profile_picture/profile_picture_model.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/user/profile_picture_options_bottomsheet.dart';
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
  final pronounController = TextEditingController();
  final countryController = TextEditingController();

  final socialControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  final profilePicNotifier = ValueNotifier<Uint8List>(Uint8List(0));
  final pronounsSelectedNotifier = ValueNotifier<List<bool>>([]);
  final countrySelectedNotifier = ValueNotifier<String>('');

  final isSavedNotifier = ValueNotifier<bool>(true);

  List<String> pronounsChips = [];

  bool isBioChanges = false;
  bool isPronounsChanges = false;
  bool isCountryChanges = false;
  bool isSocialChanges = false;

  late String initialBio;
  late String initialPronouns;
  late String initialCountry;
  late List<String> initialSocials;

  void _disposeControllers() {

    bioController.dispose();
    pronounController.dispose();
    countryController.dispose();

    for (final socials in socialControllers) {
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

  void _initializeTextFields() {
    initialBio = bioController.text;
    initialPronouns = pronounController.text;
    initialCountry = countryController.text;
    initialSocials = socialControllers.map((c) => c.text).toList();
  }

  void _initializeTextFieldsListeners() {

    bioController.addListener(() {
      final hasChanged = bioController.text != initialBio;
      isBioChanges = hasChanged;
      if (hasChanged) isSavedNotifier.value = false;
    });

    pronounController.addListener(() {
      final hasChanged = pronounController.text != initialPronouns;
      isPronounsChanges = hasChanged;
      if (hasChanged) isSavedNotifier.value = false;
    });

    countryController.addListener(() {
      final hasChanged = countryController.text != initialPronouns;
      isCountryChanges = hasChanged;
      if (hasChanged) isSavedNotifier.value = false;
    });

    for (int i = 0; i < socialControllers.length; i++) {
      socialControllers[i].addListener(() {

          final currentText = socialControllers[i].text;
          final initialText = initialSocials[i];

          final hasChanged = currentText != initialText;

          isSocialChanges = hasChanged;

          if (hasChanged) isSavedNotifier.value = false;

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
      controller.text = socialHandles![platform] ?? '';
    });

  }

  void _initializePronounsChips() {
    
    pronounsChips = [
      'he/him', 
      'she/her',
      'they/them',
    ];

    final currentPronouns = pronounController.text;

    pronounsSelectedNotifier.value = List<bool>.generate(pronounsChips.length, 
      (index) => pronounsChips[index] == currentPronouns ? true : false
    );

  }

  void _initializeProfileData() {

    profilePicNotifier.value = profileProvider.profile.profilePicture;

    bioController.text = profileProvider.profile.bio;
    bioController.addListener(_enforceBioMaxLines);

    if (profileProvider.profile.pronouns.isNotEmpty) {
      pronounController.text = profileProvider.profile.pronouns;
    }

    if (profileProvider.profile.country.isNotEmpty) {
      countryController.text = profileProvider.profile.country;
    }


  }

  Future<void> _onSaveChangesPressed() async {

    bool allSaved = true;

    if (isBioChanges) {
      if (!await _saveBio()) {
        isSavedNotifier.value = false;
        allSaved = false;
      }
    }

    if (isPronounsChanges) {
      if (!await _savePronouns()) {
        isSavedNotifier.value = false;
        allSaved = false;
      }
    }

    if (isCountryChanges) {
      if (!await _saveCountry()) {
        isSavedNotifier.value = false;
        allSaved = false;
      }
    }

    if (isSocialChanges) {
      if (!await _saveSocialLinks()) {
        isSavedNotifier.value = false;
        allSaved = false;
      }
    }

    if (allSaved) {

      initialBio = bioController.text;
      initialPronouns = pronounController.text;
      
      initialSocials = socialControllers.map((c) => c.text).toList();

      isBioChanges = false;
      isPronounsChanges = false;
      isCountryChanges = false;
      isSocialChanges = false;

      isSavedNotifier.value = true;

      SnackBarDialog.temporarySnack(message: AlertMessages.savedChanges);

    }

  }

  void _selectProfilePicture() async {

    final isProfileSelected = await ProfilePictureModel.createProfilePicture(context: context);

    if (isProfileSelected) {
      profilePicNotifier.value = profileProvider.profile.profilePicture;
      SnackBarDialog.temporarySnack(message: AlertMessages.avatarUpdated);
    }

  }

  void _onChangeAvatarPressed() async {
    
    if (profileProvider.profile.profilePicture.isEmpty) {
      _selectProfilePicture();
      return;
    }
      
    BottomsheetProfilePictureOptions().buildBottomsheet(
      context: context, 
      changeAvatarOnPressed: () {
        Navigator.pop(context);
        _selectProfilePicture();
      },
      removeAvatarOnPressed: () async {
        Navigator.pop(context);
        await ProfileDataUpdate().removeProfilePicture().then(
          (_) => profilePicNotifier.value = profileProvider.profile.profilePicture
        );
      }
    );

  }

  void _onChangeCountryPressed() async {
  
    final selectedCountry = await CountryPickerModel(context: context).startCountryPicker();

    if (selectedCountry.isNotEmpty) {
      countrySelectedNotifier.value = selectedCountry;
      countryController.text = selectedCountry;
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

        await UserSocials(platform: platform, handle: handle).addSocial();

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

      final pronouns = pronounController.text;

      await ProfileDataUpdate().updatePronouns(pronouns: pronouns);

      return true;

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.changesFailed);
      return false;
    }

  }

  Future<bool> _saveCountry() async {
// TODO: Create separated variable to initialize ProfileDataUpdate class
    try {

      await ProfileDataUpdate().updateCountry(country: countrySelectedNotifier.value);

      return true;

    } catch (_) {
      SnackBarDialog.errorSnack(message: AlertMessages.changesFailed);
      return false;
    }

  }

  void _pronounsChipsOnSelected(String pronouns) {

    if (pronouns.isEmpty) {
      pronounController.text = '';
      return;
    }

    pronounController.text = pronouns;

  }

  Widget _buildProfilePicture() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: InkWellEffect(
        onPressed: () => _onChangeAvatarPressed(),
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
                  width: 32,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ThemeColor.backgroundPrimary, width: 0.8),
                      color: ThemeColor.contentPrimary,
                      shape: BoxShape.circle
                    ),
                    child: Icon(CupertinoIcons.camera, color: ThemeColor.foregroundPrimary, size: 16),
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
              color: chipSelected[index] ?ThemeColor.foregroundPrimary : ThemeColor.contentSecondary,
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
          selectedColor: ThemeColor.contentPrimary,
          backgroundColor: ThemeColor.backgroundPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: chipSelected[index] ? ThemeColor.backgroundPrimary : ThemeColor.contentThird, 
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
                color: ThemeColor.contentThird,
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
      header: 'Pronouns', 
      children: [

        MainTextField(
          controller: pronounController, 
          hintText: "What are your pronouns?",
          maxLines: 1,
          maxLength: 14,
          inputFormatters: InputFormatters.noSpaces()
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
          hintText: "What's on your mind?",
          maxLines: 6,
          maxLength: 245,
        ),
        
        const SizedBox(height: 8),

      ]
    );
  }

  Widget _buildCountry() {
    return _buildProfileEditingWidget(
      header: 'Country', 
      children: [

        InkWellEffect(
          onPressed: _onChangeCountryPressed,
          child: AbsorbPointer(
            child: ValueListenableBuilder(
              valueListenable: countrySelectedNotifier,
              builder: (_, country, __) {
                return MainTextField(
                  controller: countryController, 
                  readOnly: true,
                  hintText: country.isNotEmpty ? country : "Select your country",
                  maxLines: 1,
                  maxLength: 14,
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

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
            color: ThemeColor.backgroundPrimary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ThemeColor.contentThird
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              FaIcon(platformIcon, color: ThemeColor.contentPrimary, size: 16), 

              const SizedBox(width: 6),

              Text(
                platform,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentSecondary,
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
          icon: Icon(Icons.check, size: 22, color: isSaved ? ThemeColor.contentThird : ThemeColor.contentPrimary),
          onPressed: () async => isSaved ? null :  await _onSaveChangesPressed(),
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

              _buildCountry(),

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
    _initializePronounsChips();
    _initializeSocialHandles();
    _initializeTextFields();
    Future.microtask(() {
      _initializeTextFieldsListeners();
    });
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
        title: 'Edit Profile',
        actions: [_buildSaveChangesButton()]
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}