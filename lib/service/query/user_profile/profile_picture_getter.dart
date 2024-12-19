import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/shared/provider/user_data_provider.dart';

class ProfilePictureGetter {

  final userData = GetIt.instance<UserDataProvider>();

  Future<Uint8List> getProfilePictures({String? username}) async {
    
    final conn = await ReventConnection.connect();

    const query = 'SELECT profile_picture FROM user_profile_info WHERE username = :username';

    final params = {
      'username': username!.isNotEmpty ? username : userData.user.username
    };

    final result = await conn.execute(query, params);

    final pfpData = ExtractData(rowsData: result).extractStringColumn('profile_picture')[0];

    return base64Decode(pfpData);
    
  }

}