import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:revent/service/profile/profile_update_service.dart';
import 'package:revent/helper/image_compressor.dart';
import 'package:revent/model/profile_picture/profile_picture_picker.dart';

class ProfilePictureModel {

  static Future<Map<String, dynamic>> createProfilePicture({required BuildContext context}) async {

    String fileName = '';
    Uint8List decodedImage = Uint8List(0);

    try {

      final pickedImages = await ProfilePicturePicker().imagePicker(context);

      for(final filesPath in pickedImages!.selectedFiles) {

        final pathToString = filesPath.selectedFile.toString().split(' ').last.replaceAll("'", '');
        
        fileName = pathToString.split('/').last.replaceAll("'", '');

        final compressedImage = await ImageCompressor.compressedByteImage(
          path: pathToString, quality: 18
        );

        decodedImage = Uint8List.fromList(compressedImage);

        await ProfileUpdateService().updateProfilePicture(picData: decodedImage);

      }

      return {
        'avatar_updated': fileName.isNotEmpty,
        'avatar_data': decodedImage
      };

    } catch (_) {
      return {
        'avatar_updated': false,
        'avatar_data': decodedImage
      };
    }

  }

}