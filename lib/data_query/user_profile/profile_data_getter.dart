import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';

class ProfileDataGetter {

  Future<Map<String, dynamic>> getData({
    required String username
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = "SELECT posts, following, followers, bio, profile_picture FROM user_profile_info WHERE username = :username";
    final param = {
      'username': username
    };

    final retrievedInfo = await conn.execute(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);

    final posts = extractData.extractIntColumn('posts')[0];
    final following = extractData.extractIntColumn('following')[0];
    final followers = extractData.extractIntColumn('followers')[0];
    final bio = extractData.extractStringColumn('bio')[0];
    final profilePic = extractData.extractStringColumn('profile_picture')[0];

    return {
      'posts': posts, 
      'followers': followers, 
      'following': following, 
      'bio': bio, 
      'profile_pic': profilePic
    };

  }

}