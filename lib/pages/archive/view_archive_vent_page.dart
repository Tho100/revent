import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/inkwell_effect.dart';
import 'package:revent/shared/widgets/profile_picture.dart';
import 'package:revent/shared/widgets/styled_text_widget.dart';

class ViewArchiveVentPage extends StatelessWidget with UserProfileProviderService {

  final String title;
  final String tags;
  final String bodyText;
  final String postTimestamp;
  final String lastEdit;

  const ViewArchiveVentPage({
    required this.title,
    required this.tags,
    required this.bodyText,
    required this.postTimestamp,
    required this.lastEdit,
    super.key
  });

  Widget _buildProfilePicture() {
    return ProfilePictureWidget(
      customHeight: 35,
      customWidth: 35,
      customEmptyPfpSize: 20,
      pfpData: profileProvider.profile.profilePicture,
    );
  }

  Widget _buildProfileHeader() {
    return InkWellEffect(
      onPressed: () => NavigatePage.userProfilePage(
        username: userProvider.user.username, pfpData: profileProvider.profile.profilePicture
      ),
      child: Row(
        children: [
    
          _buildProfilePicture(),
    
          const SizedBox(width: 10),
    
          Text(
            userProvider.user.username,
            style: GoogleFonts.inter(
              color: ThemeColor.secondaryWhite,
              fontWeight: FontWeight.w800,
              fontSize: 14.5
            ),
          ),

          const SizedBox(width: 8),
        
          Text(
            postTimestamp,
            style: GoogleFonts.inter(
              color: ThemeColor.thirdWhite,
              fontWeight: FontWeight.w800,
              fontSize: 14
            ),
          ),

          const Spacer(),

          lastEdit == '' 
            ? const SizedBox.shrink()
            : _buildLastEdit(),

        ],
      ),
    );
  }

  Widget _buildLastEdit() {
    return Row(
      children: [
  
        Icon(CupertinoIcons.pencil_outline, size: 15.5, color: ThemeColor.thirdWhite),
        
        const SizedBox(width: 6),
  
        Text(
          '${lastEdit == 'Just now' ? 'Edit just now' : 'Edit $lastEdit ago'} ',
          style: GoogleFonts.inter(
            color: ThemeColor.thirdWhite,
            fontWeight: FontWeight.w700,
            fontSize: 12.2
          )
        ),
  
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SelectableText(
          title,
          style: ThemeStyle.ventPostPageTitleStyle
        ),
        
        if(tags.isNotEmpty) ... [

          const SizedBox(height: 8),

          Text(
            tags.split(' ').map((tags) => '#$tags').join(' '),
            style: ThemeStyle.ventPostPageTagsStyle
          ),
          
          const SizedBox(height: 2),

        ],

        const SizedBox(height: 10),

        StyledTextWidget(text: bodyText),

      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 18.0, right: 18.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildProfileHeader(),

            const SizedBox(height: 18),

            _buildHeader()

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: 'Archive'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}