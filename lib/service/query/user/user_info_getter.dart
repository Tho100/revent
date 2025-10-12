import 'package:revent/helper/extract_data.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class UserInfoGetter {

  static Future<String> getJoinedDate({required String username}) async {

    final response = await ApiClient.get(ApiPath.userJoinedDateGetter, username);

    return response.body!['joined_date'];

  }

  static Future<String> getCountry({required String username}) async {

    final response = await ApiClient.get(ApiPath.userCountryGetter, username);

    return response.body!['country'];

  }

  static Future<Map<String, String>> getSocialHandles({String? username}) async {

    final response = await ApiClient.get(ApiPath.userSocialHandlesGetter, username);

    final socialHandlesBody = response.body!['social_handles'] as List<dynamic>;

    if (socialHandlesBody.isEmpty) {
      return {};
    } 

    final extractedData = ExtractData(data: socialHandlesBody);

    final platforms = extractedData.extractColumn<String>('platform');
    final handles = extractedData.extractColumn<String>('social_handle');

    final socialHandles = Map.fromIterables(
      platforms,
      handles,
    )..removeWhere((_, handle) => handle.isEmpty);
    
    return socialHandles;

  }

}