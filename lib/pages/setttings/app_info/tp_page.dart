import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/app_bar.dart';

class TermAndConditionsPage extends StatelessWidget {

  const TermAndConditionsPage({super.key});

  String _buildMessage() {
    return '''
    Terms and Conditions for Revent
    Effective Date: November 13, 2024

    By using the Revent app (the "Service"), you agree to comply with and be bound by the following terms and conditions. Please read them carefully.

    1. Acceptance of Terms

    By accessing or using the Revent app, you agree to abide by these Terms and Conditions and any additional rules, policies, or guidelines that may apply to specific features of the Service. If you do not agree with these terms, please do not use the Service.

    2. User Registration

    To access and use certain features of Revent, you may need to register an account. During registration, you agree to provide accurate and complete information, including but not limited to:

    Username
    Email address
    Password

    You are responsible for maintaining the confidentiality of your login information and for all activities under your account.

    3. Data Collected

    We collect the following personal data to provide and enhance the Service:

    Username
    Email address
    Password
    Photo media gallery (for the purpose of uploading and sharing photos)

    By using the Service, you consent to the collection and use of your personal information as described in this section.

    4. Use of Your Data

    The data we collect is used for the following purposes:

    To create and manage your user account.
    To allow you to upload and share photos.
    To communicate with you regarding updates, security, and other important notices.
    To provide customer support, if necessary.
    5. Privacy

    Your privacy is important to us. Please refer to our Privacy Policy for details on how we collect, store, and protect your personal data.

    6. User Obligations

    By using the Revent app, you agree not to:

    Violate any applicable laws or regulations.
    Use the Service for any unlawful, harmful, or fraudulent activities.
    Upload or share any content that is offensive, defamatory, or violates the rights of others.
    Attempt to gain unauthorized access to other users' accounts or the Service.

    7. Termination

    We may suspend or terminate your access to the Service at any time, without notice, if you violate these Terms and Conditions.

    8. Limitations of Liability

    The Service is provided "as is," without warranties of any kind, either express or implied. Revent is not responsible for any loss or damage resulting from the use of the Service, including but not limited to any errors or omissions in the content, or any interruption or loss of data.

    9. Modifications

    We reserve the right to update, modify, or change these Terms and Conditions at any time. When we do so, we will update the "Effective Date" at the top of this document. We encourage you to review these terms periodically for any changes.

    10. Governing Law

    These Terms and Conditions are governed by the laws of Malaysia. Any disputes arising out of or in connection with these terms will be resolved in the appropriate courts of Malaysia.

    11. Contact Information

    If you have any questions about these Terms and Conditions, please contact us at:

    Email: revent@gmail.com
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.contentPrimary,
      appBar: CustomAppBar(
        context: context,
        title: 'Term and Conditions'
      ).buildAppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.92,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 12, left: 25),
            child: Text(
              _buildMessage(),
              style: GoogleFonts.inter(
                color: ThemeColor.foregroundPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      )
    );
  }

}