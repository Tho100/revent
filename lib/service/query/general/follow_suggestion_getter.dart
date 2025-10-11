import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class FollowSuggestionGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, dynamic>> getSuggestion() async {

    final response = await ApiClient.get(ApiPath.userFollowSuggestionsGetter, userProvider.user.username);

    final profiles = ExtractData(data: response.body!['profiles']);

    final usernames = profiles.extractColumn<String>('username');
    
    final profilePictures = DataConverter.convertToPfp(
      profiles.extractColumn<String>('profile_picture')
    );

    return {
      'usernames': usernames,
      'profile_pic': profilePictures
    };

  }

}