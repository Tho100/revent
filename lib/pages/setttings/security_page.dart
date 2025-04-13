import 'package:flutter/material.dart';
import 'package:revent/pages/setttings/security/change_password_page.dart';
import 'package:revent/pages/setttings/security/deactivate_account_page.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/buttons/settings_button.dart';

class SecurityPage extends StatelessWidget {

  const SecurityPage({super.key});

  Widget _borderedContainer(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: ThemeColor.lightGrey,
            width: 0.8
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: child,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: ThemeColor.lightGrey,
                  width: 0.8
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
              
                    const SizedBox(height: 8),
              
                    SettingsButton(
                      text: 'Change password', 
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChangePasswordPage())
                        );
                      }
                    ),
                        
                    const SizedBox(height: 8),
                        
                    SettingsButton(
                      text: 'Recovery key', 
                      onPressed: () {}
                    ),
              
                    const SizedBox(height: 8),
                    
                  ],
                ),
              ),
            ),
          ),
          
          _borderedContainer(
            SettingsButton(
              text: 'Deactivate account', 
              makeRed: true,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeactivateAccountPage())
                );
              }
            ),
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
        title: 'Security'
      ).buildAppBar(),
      body: _buildBody(context),
    );
  }

}