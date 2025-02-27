import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/user/user_data_getter.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';

class AccountInformationPage extends StatefulWidget {

  const AccountInformationPage({super.key});

  @override
  State<AccountInformationPage> createState() => _AccountInformationPageState();

}

class _AccountInformationPageState extends State<AccountInformationPage> with UserProfileProviderService {

  Future<String> _loadJoinedDate() async {

    if(userProvider.user.joinedDate == null) {

      final getJoinedDate = await UserDataGetter().getJoinedDate(
        username: userProvider.user.username
      );

      final formattedJoinedDate = FormatDate().formatLongDate(getJoinedDate);

      userProvider.setJoinedDate(formattedJoinedDate);

      return formattedJoinedDate;

    }

    return userProvider.user.joinedDate!;

  }

  Widget _buildHeaders(String header, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
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

  Widget _buildJoinedDate() {
    return FutureBuilder<String>(
      future: _loadJoinedDate(),
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

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                        
            _buildHeaders('Username', userProvider.user.username),
            _buildHeaders('Email', userProvider.user.email),

            _buildJoinedDate(),
                  
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
        title: 'Account information'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }
  
}