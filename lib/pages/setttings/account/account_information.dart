import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/main_button.dart';

class AccountInformationPage extends StatelessWidget {

  AccountInformationPage({super.key});

  final userData = GetIt.instance<UserDataProvider>();

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

  Widget _buildUpgradeButton(BuildContext context) {
    return MainButton(
      customWidth: MediaQuery.of(context).size.width * 0.26,
      customHeight: 46,
      customFontSize: 15,
      text: 'Upgrade', 
      onPressed: () => print('Upgrade')
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 12),
                        
            _buildHeaders('Username', '@${userData.username}'),
            _buildHeaders('Email', userData.email),
            _buildHeaders('Plan', userData.plan),
      
            _buildUpgradeButton(context), 
                  
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
      body: _buildBody(context),
    );
  }

}