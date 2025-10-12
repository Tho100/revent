import 'dart:convert';
import 'dart:typed_data';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class ProfilePictureGetter {

  Future<Uint8List> getProfilePictures({String? username}) async {

    if (username == getIt.userProvider.user.username) {
      return getIt.profileProvider.profile.profilePicture;
    }

    final response = await ApiClient.get(ApiPath.userAvatarGetter, username!);

    final avatar = response.body!['avatar'];

    final pfpData = base64Decode(avatar);

    return pfpData;
    
  }

}