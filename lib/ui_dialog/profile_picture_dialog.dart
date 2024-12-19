import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:revent/global/constant.dart';
import 'package:revent/shared/widgets/profile_picture.dart';

class ProfilePictureDialog {

  Future showPfpDialog(Uint8List pfpData) {
    return showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: true, 
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [

              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.of(navigatorKey.currentContext!).pop(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
              ),

              Center(
                child: ProfilePictureWidget(
                  customWidth: 200,
                  customHeight: 200,
                  pfpData: pfpData,
                )
              ),
              
            ],
          ),
        );
      },
    );
  }

}