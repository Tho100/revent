import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/ui_dialog/page_loading.dart';

class SpinnerLoading {

  late BuildContext context;
  
  Future<void> startLoading({
    required BuildContext context
  }) {

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
        side: ThemeStyle.dialogSideBorder,
        borderRadius: BorderRadius.circular(14),
      ),
      title: const SizedBox(
        height: 85,
        width: 85,
        child: PageLoading()
      ), 
    );
  }

}