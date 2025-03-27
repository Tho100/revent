import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';

class BottomsheetBar extends StatelessWidget {

  const BottomsheetBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 35,
          height: 6,
          decoration: BoxDecoration(
            color: ThemeColor.thirdWhite,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

}