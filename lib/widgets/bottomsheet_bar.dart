import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';

class BottomsheetBar extends StatelessWidget {

  const BottomsheetBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 35,
        height: 5,
        decoration: BoxDecoration(
          color: ThemeColor.darkWhite,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

}