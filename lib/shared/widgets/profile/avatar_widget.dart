import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:revent/shared/themes/theme_color.dart';

class ProfilePictureWidget extends StatelessWidget {
  
  final double? customWidth;
  final double? customHeight;
  final double? customEmptyPfpSize;
  final Uint8List? pfpData;

  const ProfilePictureWidget({
    this.pfpData,
    this.customWidth,
    this.customHeight,
    this.customEmptyPfpSize,
    super.key
  });

  Widget _buildEmptyPfp() {
    return Icon(
      CupertinoIcons.person, 
      color: ThemeColor.foregroundPrimary, size: customEmptyPfpSize ?? 18 
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
        color: (pfpData == null || pfpData!.isEmpty) ? ThemeColor.contentPrimary : ThemeColor.backgroundPrimary,
        shape: BoxShape.circle,
      ),
      child: (pfpData != null && pfpData!.isNotEmpty)
        ? _buildPfp(pfpData: pfpData!)
        : _buildEmptyPfp()
    );
  }

}