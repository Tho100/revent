import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';

class ProfilePictureWidget extends StatelessWidget {
  
  final double? customWidth;
  final double? customHeight;
  final ValueNotifier<Uint8List?> profileDataNotifier;

  const ProfilePictureWidget({
    required this.profileDataNotifier,
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
      child: ValueListenableBuilder(
        valueListenable: profileDataNotifier,
        builder: (context, imageData, child) {
          return imageData!.isEmpty 
            ? const Icon(CupertinoIcons.person, color: Colors.white)
            : ClipOval(
              child: Image.memory(
                imageData, 
                fit: BoxFit.cover
            ),
          );
        },
      ),
    );
  }

}