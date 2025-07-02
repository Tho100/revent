import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';

class SingleTextLoading {

  late String title;
  late BuildContext context;

  SingleTextLoading({required this.context});
  
  Future<void> startLoading({required String title}) {

    this.title = title;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _buildLoadingDialog(),
    );

  }

  void stopLoading() => Navigator.pop(context);

  AlertDialog _buildLoadingDialog() {
    return AlertDialog(
      backgroundColor: ThemeColor.backgroundPrimary,
      shape: RoundedRectangleBorder(
        side: ThemeStyle.dialogSideBorder,
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