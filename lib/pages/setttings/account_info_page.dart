import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/data_query/user_data_getter.dart';
import 'package:revent/model/format_date.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/sub_button.dart';

class AccountInformationPage extends StatefulWidget {

  const AccountInformationPage({super.key});

  @override
  State<AccountInformationPage> createState() => AccountInformationPageState();

}

class AccountInformationPageState extends State<AccountInformationPage> {

  final userData = GetIt.instance<UserDataProvider>();

  Future<String> _loadJoinedDate() async {

    if(userData.user.joinedDate == null) {

      final conn = await ReventConnect.initializeConnection();

      final getJoinedDate = await UserDataGetter()
        .getJoinedDate(conn: conn, username: userData.user.username);

      final formattedJoinedDate = FormatDate().formatLongDate(getJoinedDate);

      userData.setJoinedDate(formattedJoinedDate);

      return formattedJoinedDate;

    } else {
      return userData.user.joinedDate!;

    }

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

  Widget _buildUpgradeButton() {
    return SubButton(
      text: 'Upgrade', 
      onPressed: () => print('Upgrade')
    );
  }

  Widget _buildJoinedDate() {
    return FutureBuilder<String>(
      future: _loadJoinedDate(),
      builder: (_, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildHeaders('Joined date', '...');

        } else if (snapshot.hasError) {
          return _buildHeaders('Joined date', '0/0/0');

        } else {
          return _buildHeaders('Joined date', snapshot.data ?? '0/0/0');

        }

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
                        
            _buildHeaders('Username', '@${userData.user.username}'),
            _buildHeaders('Email', userData.user.email),

            _buildJoinedDate(),
      
            _buildHeaders('Plan', userData.user.plan),
            _buildUpgradeButton(), 
                  
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
        title: 'Account Information'
      ).buildAppBar(),
      body: _buildBody(),
    );
  }
  
}