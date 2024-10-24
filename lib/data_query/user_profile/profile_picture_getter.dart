import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/provider/user_data_provider.dart';

class ProfilePictureGetter {

  Future<Uint8List> getProfilePictures({String? username}) async {
    
    final userData = GetIt.instance<UserDataProvider>();

    final conn = await ReventConnect.initializeConnection();

    const query = "SELECT profile_picture FROM user_profile_info WHERE username = :username";
    final params = {
      'username': username!.isNotEmpty ? username : userData.user.username
    };

    final result = await conn.execute(query, params);

    final pfpData = ExtractData(rowsData: result).extractStringColumn('profile_picture');
    return base64Decode(pfpData[0]);
    
  }

}