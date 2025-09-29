import 'dart:convert';
import 'dart:typed_data';

import 'package:revent/global/table_names.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class ProfilePictureGetter extends BaseQueryService {

  Future<Uint8List> getProfilePictures({String? username}) async {
    // TODO: Try to remove this and merge it into queries instead, for example on vents-getter
    if (username == getIt.userProvider.user.username) {
      return getIt.profileProvider.profile.profilePicture;
    }

    const query = 'SELECT profile_picture FROM ${TableNames.userProfileInfo} WHERE username = :username';

    final param = {
      'username': username!.isNotEmpty ? username : getIt.userProvider.user.username
    };

    final result = await executeQuery(query, param);

    final pfpData = ExtractData(rowsData: result).extractStringColumn('profile_picture')[0];

    return base64Decode(pfpData);
    
  }

}