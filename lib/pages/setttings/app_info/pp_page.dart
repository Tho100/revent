import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {

  const PrivacyPolicyPage({super.key});

  String _buildMessage() {
    return '''
    Privacy Policy for Revent
    Effective Date: November 13, 2024

    Revent ("we", "us", or "our") is committed to protecting your privacy. This Privacy Policy outlines how we collect, use, and protect your personal information when you use the Revent app (the "Service"). By using the Service, you agree to the collection and use of information in accordance with this policy.

    1. Information We Collect

    To provide and improve the Service, we collect the following types of personal information:

    Username: The name you provide during registration.
    Email Address: Used for account management, notifications, and communication.
    Password: For securing your account.
    Photo Media Gallery: Photos uploaded by you as part of using the app.

    2. How We Use Your Information

    We use the information we collect for the following purposes:

    To create and manage your account on Revent.
    To allow you to upload, manage, and share photos.
    To send important updates, security alerts, and notifications related to the Service.
    To respond to your inquiries or provide customer support.
    To improve the functionality and performance of the app.
    3. Data Storage and Security

    We take your privacy seriously and employ reasonable measures to protect your personal information. However, please note that no method of data transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your personal data, we cannot guarantee its absolute security.

    4. Sharing Your Information

    We do not sell, rent, or share your personal data with third parties, except in the following cases:

    Service Providers: We may share your data with trusted third-party service providers who assist in the operation of the Service (e.g., hosting services, data analytics).
    Legal Compliance: We may disclose your personal data if required to do so by law or in response to valid requests by public authorities (e.g., court orders or government agencies).
    5. Data Retention
    We will retain your personal information only for as long as necessary to fulfill the purposes outlined in this Privacy Policy. If you wish to delete your account or your data, you may contact us directly at revent@gmail.com. However, we may need to retain certain information to comply with legal obligations or resolve disputes.

    6. User Rights

    As a user, you have the right to:

    Access: Request access to the personal data we hold about you.
    Correction: Request corrections to any inaccurate or incomplete personal data.
    Deletion: Request that we delete your personal data, subject to legal obligations.
    Opt-Out: Opt-out of receiving promotional or marketing emails by following the unsubscribe instructions in the email.

    7. Cookies and Tracking Technologies

    We may use cookies and similar tracking technologies to enhance your experience with the Service. These technologies help us analyze trends, administer the app, track users' movements around the app, and gather demographic information. You can manage your cookie preferences in your device settings.

    8. Children's Privacy

    Revent does not knowingly collect or solicit personal data from anyone under the age of 13. If we learn that we have collected personal data from a child under 13, we will take steps to delete that information as soon as possible. If you are a parent or guardian and believe we have collected personal data from your child, please contact us immediately.

    9. Changes to This Privacy Policy

    We may update this Privacy Policy from time to time to reflect changes in our practices or for other operational, legal, or regulatory reasons. We will notify you of any significant changes by posting the updated Privacy Policy in the app and updating the "Effective Date" at the top of this document.

    10. Contact Us
    
    If you have any questions or concerns about this Privacy Policy or the way your personal data is handled, please contact us at:

    Email: revent@gmail.com
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.white,
      appBar: CustomAppBar(
        context: context,
        title: 'Privacy Policy'
      ).buildAppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.92,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 12, left: 25),
            child: Text(
              _buildMessage(),
              style: GoogleFonts.inter(
                color: ThemeColor.mediumBlack,
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