import 'package:revent/global/table_names.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class ProfileDataGetter extends BaseQueryService {

  Future<Map<String, dynamic>> getProfileData({
    required bool isMyProfile,
    required String username
  }) async {

    final query = isMyProfile 
      ? 'SELECT following, followers, bio, pronouns, country, profile_picture FROM ${TableNames.userProfileInfo} WHERE username = :username'
      : 'SELECT following, followers, bio, pronouns, country FROM ${TableNames.userProfileInfo} WHERE username = :username';

    final param = {'username': username};

    final retrievedInfo = await executeQuery(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);

    final following = extractData.extractIntColumn('following')[0];
    final followers = extractData.extractIntColumn('followers')[0];
    
    final bio = extractData.extractStringColumn('bio')[0];
    final pronouns = extractData.extractStringColumn('pronouns')[0];
    final country = extractData.extractStringColumn('country')[0];

    final results = {
      'followers': followers, 
      'following': following, 
      'bio': bio,
      'pronouns': pronouns,
      'country': country
    };

    if (isMyProfile) {
      results['profile_pic'] = extractData.extractStringColumn('profile_picture')[0];
    }

    return results;

  }

}