import 'dart:convert';
import 'dart:typed_data';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class ProfilePictureGetter extends BaseQueryService {

  Future<Uint8List> getProfilePictures({String? username}) async {
    // TODO: Do not use this for vents-getter, instead merge into one query
    if (username == getIt.userProvider.user.username) {
      return getIt.profileProvider.profile.profilePicture;
    }

    final response = await ApiClient.get(ApiPath.userAvatarGetter, username!);

    final avatar = response.body!['avatar'];

    final pfpData = base64Decode(avatar);

    return pfpData;
    
  }

}