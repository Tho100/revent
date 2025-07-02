import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/themes/theme_style.dart';
import 'package:revent/shared/widgets/ui_dialog/page_loading.dart';

class SpinnerLoading {

  late BuildContext context;

  SpinnerLoading({required this.context});
  
  Future<void> startLoading() {

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
      title: const SizedBox(
        height: 85,
        width: 85,
        child: PageLoading()
      ), 
    );
  }

}