import 'dart:convert';
import 'dart:typed_data';

import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class ProfileDataUpdate extends BaseQueryService with UserProfileProviderService {

  Future<void> updateBio({required String bioText}) async {

    final response = await ApiClient.post(ApiPath.updateUserBio, {
      'bio': bioText,
      'username': userProvider.user.username
    });    

    if (response.statusCode == 200) {
      profileProvider.updateBio(bioText);
    }

  }

  Future<void> updateProfilePicture({required Uint8List picData}) async {

    final base64Pfp = const Base64Encoder().convert(picData);

    final response = await ApiClient.put(ApiPath.updateUserAvatar, {
      'username': userProvider.user.username,
      'pfp_base64': base64Pfp,
    });
    
    if (response.statusCode == 200) {
      profileProvider.updateProfilePicture(picData);
    }

  }

  Future<void> removeProfilePicture() async {

    final response = await ApiClient.put(ApiPath.updateUserAvatar, {
      'username': userProvider.user.username,
      'pfp_base64': '',
    });
    
    if (response.statusCode == 200) {
      profileProvider.updateProfilePicture(Uint8List(0));
    }

  }

  Future<void> updatePronouns({required String pronouns}) async {

    final response = await ApiClient.post(ApiPath.updateUserPronouns, {
      'pronouns': pronouns,
      'username': userProvider.user.username
    });    

    if (response.statusCode == 200) {
      profileProvider.updatePronouns(pronouns);
    }

  }

  Future<void> updateCountry({required String country}) async {

    final response = await ApiClient.post(ApiPath.updateUserCountry, {
      'country': country,
      'username': userProvider.user.username
    });    

    if (response.statusCode == 200) {
      profileProvider.profile.country = country;
    }

  }

}