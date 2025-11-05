import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/model/local_storage_model.dart';
import 'package:revent/pages/profile_picture_viewer_page.dart';
import 'package:revent/helper/format/format_date.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/boredered_container.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile/avatar_widget.dart';

class AccountInformationPage extends StatefulWidget {

  const AccountInformationPage({super.key});

  @override
  State<AccountInformationPage> createState() => _AccountInformationPageState();

}

class _AccountInformationPageState extends State<AccountInformationPage> with UserProfileProviderService {

  Future<String> _initializeJoinDate() async {

    if (userProvider.user.joinedDate == null) {

      final joinedDate = (await LocalStorageModel().readAccountInformation())['joined_date']!;
          
      final formattedJoinedDate = FormatDate.formatLongDate(joinedDate);

      userProvider.setJoinedDate(formattedJoinedDate);

      return formattedJoinedDate;

    }

    return userProvider.user.joinedDate!;

  }

  Widget _buildHeaders(String header, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 14.0),
      child: Row(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 8),
              
              Text(
                header,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentThird,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
    
              const SizedBox(height: 8),
    
              Text(
                value,
                style: GoogleFonts.inter(
                  color: ThemeColor.contentPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
    
              const SizedBox(height: 8),
    
            ],
          ),

          const Spacer(),

        ],
      ),
    );
  }

  Widget _buildJoinedDate() {
    return FutureBuilder<String>(
      future: _initializeJoinDate(),
      builder: (_, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildHeaders('Joined', '...');

        } else if (snapshot.hasError) {
          return _buildHeaders('Joined', '0/0/0');

        } 

        return _buildHeaders('Joined', snapshot.data ?? '0/0/0');

      },
    );
  }

  Widget _buildPrimaryInfo() {
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 14.0),
          child: InkWellEffect(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePictureViewer(pfpData: profileProvider.profile.profilePicture)
                )
              );
            },
            child: Hero(
              tag: 'profile-picture-hero',
              child: ProfilePictureWidget(
                pfpData: profileProvider.profile.profilePicture,
                customEmptyPfpSize: 35,
                customHeight: 100,
                customWidth: 100,
              ),
            ),
          ),
        ),

        Center(
          child: Text(
            userProvider.user.username,
            style: GoogleFonts.inter(
              color: ThemeColor.contentPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 21
            ),
          ),
        ),

      ],
    );
  }

  String _hiddenEmailString(String email) {

    final emailValue = email.split('@')[0];
  
    final middleEmail = emailValue.substring(1, emailValue.length - 1);

    final emailDomain = '@${email.split('@')[1]}';

    return '*$middleEmail*$emailDomain';

  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          _buildPrimaryInfo(),

          const SizedBox(height: 25),

          BorderedContainer(
            child: _buildHeaders('Email', _hiddenEmailString(userProvider.user.email))
          ),
    
          BorderedContainer(
            child: _buildJoinedDate()
          ),
                
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Account Information'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }
  
}