import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:revent/service/query/user_profile/profile_data_update.dart';
import 'package:revent/helper/image_compressor.dart';
import 'package:revent/model/profile_picture/profile_picture_picker.dart';

class ProfilePictureModel {

  Future<bool> createProfilePicture(BuildContext context) async {

    try {

      String fileName = "";

      final pickedImages = await ProfilePicturePicker().imagePicker(context);

      for(final filesPath in pickedImages!.selectedFiles) {

        final pathToString = filesPath.selectedFile.toString()
          .split(" ").last.replaceAll("'", "");
        
        fileName = pathToString.split("/")
          .last.replaceAll("'", "");

        final compressedImage = await ImageCompressor
          .compressedByteImage(path: pathToString, quality: 18);

        final decodedImage = Uint8List.fromList(compressedImage);

        await ProfileDataUpdate().updateProfilePicture(picData: decodedImage);

      }

      return fileName.isNotEmpty;

    } catch (_) {
      return false;
    }

  }

}