import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';

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
      backgroundColor: ThemeColor.darkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      title: const SizedBox(
        height: 85,
        width: 85,
        child: Center(child: CircularProgressIndicator(color: ThemeColor.white, strokeWidth: 2)),
      ), 
    );
  }

}