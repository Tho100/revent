import 'package:revent/helper/data_converter.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class UserPrivacyActions extends BaseQueryService {

  Future<Map<String, dynamic>> makeProfilePrivate({required bool isPrivate}) async {
    return await _updatePrivacyOptions(
      param: 'is_private', value: isPrivate, path: ApiPath.makeUserPrivate
    );
  }

  Future<Map<String, dynamic>> hideFollowingList({required bool isHidden}) async {
    return await _updatePrivacyOptions(
      param: 'is_hidden', value: isHidden, path: ApiPath.makeUserPrivate
    );
  }

  Future<Map<String, dynamic>> hideSavedPosts({required bool isHidden}) async {
    return await _updatePrivacyOptions(
      param: 'is_hidden', value: isHidden, path: ApiPath.hideUserSaved
    );
  }

  Future<Map<String, dynamic>> _updatePrivacyOptions({
    required bool value,
    required String param, 
    required String path
  }) async {

    final valueBoolToInt = DataConverter.convertBoolToInt(value);

    final response = await ApiClient.post(path, {
      'username': getIt.userProvider.user.username,
      param: valueBoolToInt
    });

    return {
      'status_code': response.statusCode
    };

  }

  Future<Map<String, int>> getCurrentPrivacyOptions({required String username}) async {

    final response = await ApiClient.get(ApiPath.userPrivacyOptionsGetter, username);

    final options = ExtractData(data: response.body!['options']);

    final privatedAccount = options.extractColumn<int>('privated_profile')[0];
    final privatedFollowing = options.extractColumn<int>('privated_following_list')[0];
    final privatedSaved = options.extractColumn<int>('privated_saved_vents')[0];
 
    return {
      'account': privatedAccount,
      'following': privatedFollowing,
      'saved': privatedSaved,
    };

  }

}