import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_profile/profile_data_update.dart';
import 'package:revent/model/compressor.dart';
import 'package:revent/model/profile_picture_picker.dart';
import 'package:revent/provider/profile_data_provider.dart';

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

        final compressedImage = await Compressor
          .compressedByteImage(path: pathToString, quality: 18);

        final decodedImage = Uint8List.fromList(compressedImage);

        await ProfileDataUpdate().updateProfilePicture(picData: decodedImage);

      }

      return fileName.isNotEmpty;

    } catch (err) {
      return false;
    }

  }

  Future<ValueNotifier<Uint8List?>> initializeProfilePic() async {
    
    final profileData = GetIt.instance<ProfileDataProvider>();

    final profilePictureNotifier = ValueNotifier<Uint8List?>(Uint8List(0));

    try {

      final picData = profileData.profilePicture;

      if(picData.isEmpty) {
        profilePictureNotifier.value = Uint8List(0);

      } else {
        profilePictureNotifier.value = picData;   

      }
      
      return profilePictureNotifier;

    } catch (err) {
      return profilePictureNotifier;

    }

  }

}