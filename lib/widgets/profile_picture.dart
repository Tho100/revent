import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';

class ProfilePictureWidget extends StatelessWidget {
  
  final double? customWidth;
  final double? customHeight;
  final Uint8List? pfpData;
  final ValueNotifier<Uint8List?>? profileDataNotifier;

  const ProfilePictureWidget({
    this.profileDataNotifier,
    this.pfpData,
    this.customWidth,
    this.customHeight,
    super.key
  });

  final defaultEmptyIcon = const Icon(
    CupertinoIcons.person, 
    color: ThemeColor.mediumBlack
  );

  Widget _buildNotifierPfp() {
    return ValueListenableBuilder<Uint8List?>(
      valueListenable: profileDataNotifier!,
      builder: (_, imageData, __) {
        return imageData == null 
          ? defaultEmptyIcon
          : _buildPfp(pfpData: imageData);
      },
    );
  }

  Widget _buildPfp({required Uint8List pfpData}) {
    return ClipOval(
      child: Image.memory(
        pfpData,
        fit: BoxFit.cover,
        width: customWidth ?? 65,
        height: customHeight ?? 65,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: customWidth ?? 65,
      height: customHeight ?? 65,
      decoration: BoxDecoration(
        color: (pfpData == null || pfpData!.isEmpty) ? ThemeColor.white : ThemeColor.black,
        shape: BoxShape.circle,
      ),
      child: (pfpData != null && pfpData!.isNotEmpty)
        ? _buildNotifierPfp()
        : defaultEmptyIcon, 
    );
  }

}