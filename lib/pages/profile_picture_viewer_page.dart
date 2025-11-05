import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/shared/widgets/profile/avatar_widget.dart';

class ProfilePictureViewer extends StatelessWidget {
  
  final Uint8List pfpData;

  const ProfilePictureViewer({
    required this.pfpData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: 'profile-picture-hero',
            child: ProfilePictureWidget(
              customWidth: 200,
              customHeight: 200,
              pfpData: pfpData,
              customEmptyPfpSize: 85,
            ),
          ),
        ),
      ),
    );
  }

}
