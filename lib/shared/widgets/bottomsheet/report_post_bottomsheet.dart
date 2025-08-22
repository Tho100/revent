import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/helper/navigator_extension.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_header.dart';
import 'package:revent/shared/widgets/bottomsheet/bottomsheet_widgets/bottomsheet_option_button.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';

class ReportPostBottomsheet {

  void _onReportPressed(BuildContext context, String type) {
    context.popAndRun(
      () => CustomAlertDialog.alertDialogTitle('Report Submitted', 'Thank you for making Revent a better place!')
    );
  }

  Future buildBottomsheet({required BuildContext context}) {
    return Bottomsheet().buildBottomSheet(
      context: context, 
      children: [

        const BottomsheetHeader(title: 'Report Post'),

        Align(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Select a report reason',
              style: GoogleFonts.inter(
                color: ThemeColor.contentThird,
                fontSize: 14,
                fontWeight: FontWeight.w800
              ),
            ),
          ),
        ),

        BottomsheetOptionButton(
          text: 'Spam', 
          onPressed: () => _onReportPressed(context, 'spam')
        ),

        BottomsheetOptionButton(
          text: 'Scam or fraud', 
          onPressed: () => _onReportPressed(context, 'scam_fraud')
        ),

        BottomsheetOptionButton(
          text: 'Inappropriate content involving minors', 
          onPressed: () => _onReportPressed(context, 'inappropriate')
        ),

        BottomsheetOptionButton(
          text: 'Promotion of illegal activity', 
          onPressed: () => _onReportPressed(context, 'illegal_activity')
        ),

        BottomsheetOptionButton(
          text: 'Encouraging self-harm or suicide', 
          onPressed: () => _onReportPressed(context, 'self_harm')
        ),

        BottomsheetOptionButton(
          text: 'Threats or harassment', 
          onPressed: () => _onReportPressed(context, 'threats')
        ),

        BottomsheetOptionButton(
          text: 'Impersonation or identity theft', 
          onPressed: () => _onReportPressed(context, 'identity_theft')
        ),

        const SizedBox(height: 25)

      ]
    );
  }

}