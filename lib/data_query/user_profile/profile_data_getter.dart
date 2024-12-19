import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/model/extract_data.dart';

class ProfileDataGetter {

  Future<Map<String, dynamic>> getProfileData({
    required bool isMyProfile,
    required String username
  }) async {

    final conn = await ReventConnection.connect();

    final query = isMyProfile 
      ? 'SELECT following, followers, bio, pronouns, profile_picture FROM user_profile_info WHERE username = :username'
      : 'SELECT following, followers, bio, pronouns FROM user_profile_info WHERE username = :username';

    final param = {
      'username': username
    };

    final retrievedInfo = await conn.execute(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);

    final following = extractData.extractIntColumn('following')[0];
    final followers = extractData.extractIntColumn('followers')[0];
    
    final bio = extractData.extractStringColumn('bio')[0];
    final pronouns = extractData.extractStringColumn('pronouns')[0];

    final results = {
      'followers': followers, 
      'following': following, 
      'bio': bio,
      'pronouns': pronouns
    };

    if (isMyProfile) {
      results['profile_pic'] = extractData.extractStringColumn('profile_picture')[0];
    }

    return results;

  }

}