import 'dart:convert';
import 'dart:typed_data';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class ProfilePictureGetter extends BaseQueryService {

  Future<Uint8List> getProfilePictures({String? username}) async {
    
    const query = 'SELECT profile_picture FROM user_profile_info WHERE username = :username';

    final params = {
      'username': username!.isNotEmpty ? username : getIt.userProvider.user.username
    };

    final result = await executeQuery(query, params);

    final pfpData = ExtractData(rowsData: result).extractStringColumn('profile_picture')[0];

    return base64Decode(pfpData);
    
  }

}