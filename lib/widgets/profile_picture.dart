import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';

class ProfilePictureWidget extends StatelessWidget {
  
  final double? customWidth;
  final double? customHeight;

  const ProfilePictureWidget({
    this.customWidth,
    this.customHeight,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: customWidth ?? 65,
      height: customHeight ?? 65,
      decoration: const BoxDecoration(
        color: ThemeColor.white,
        shape: BoxShape.circle
      ),
    );
  }

}