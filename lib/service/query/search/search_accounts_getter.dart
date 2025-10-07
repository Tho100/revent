import 'package:revent/helper/data_converter.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
// TODO: Rename to profiles
class SearchAccountsGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, List<dynamic>>> getAccounts({required String searchUsername}) async {

    final response = await ApiClient.post(ApiPath.searchProfilesGetter, {
      'search_username': searchUsername,
      'current_user': userProvider.user.username
    });

    final profiles = ExtractData(data: response.body!['profiles']);

    final usernames = profiles.extractColumn<String>('username');

    final profilePictures = DataConverter.convertToPfp(
      profiles.extractColumn<String>('profile_picture')
    );
    
    return {
      'username': usernames,
      'profile_pic': profilePictures,
    };

  }

}