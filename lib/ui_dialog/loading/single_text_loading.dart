import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';

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
      backgroundColor: ThemeColor.darkGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      title: Row(
        children: [

          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(color: ThemeColor.white),
          ),

          const SizedBox(width: 25),

          Text(title,
            style: const TextStyle(
              color: ThemeColor.secondaryWhite,
              fontSize: 18,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 25),

        ]
      ),
    );
  }

}