import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';

class SingleTextLoading {

  late String title;
  late BuildContext context;
  
  Future<void> startLoading({
    required String title,
    required BuildContext context
  }) {

    this.title = title;
    this.context = context;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _buildLoadingDialog(context),
    );

  }

  void stopLoading() {
    Navigator.pop(context);
  }

  AlertDialog _buildLoadingDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeColor.backgroundPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      title: Row(
        children: [

          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: ThemeColor.contentPrimary),
          ),

          const SizedBox(width: 25),

          Text(
            title,
            style: GoogleFonts.inter(
              color: ThemeColor.contentSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 25),

        ]
      ),
    );
  }

}