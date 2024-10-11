import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/data_query/user_profile/profile_data_update.dart';
import 'package:revent/model/compressor.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/model/profile_picture_picker.dart';
import 'package:revent/provider/user_data_provider.dart';

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

  Future<Uint8List> getProfilePicture() async {

    final userData = GetIt.instance<UserDataProvider>();

    final conn = await ReventConnect.initializeConnection();

    const query = "SELECT profile_picture FROM user_profile_info WHERE username = :username";
    final params = {'username': userData.username};

    final result = await conn.execute(query, params);

    final pfpData = ExtractData(rowsData: result).extractStringColumn('profile_picture');
    return base64Decode(pfpData[0]);
    
  }

}