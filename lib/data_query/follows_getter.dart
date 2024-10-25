import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/provider/user_data_provider.dart';

class FollowsGetter {

  final userData = GetIt.instance<UserDataProvider>();

  Future<List<String>> getFollows({required String followType}) async {

    final conn = await ReventConnect.initializeConnection();

    final query = followType == 'Followers' 
      ? 'SELECT * FROM user_follows_info WHERE following = :username'
      : 'SELECT * FROM user_follows_info WHERE followers = :username';

    final param = {'username': userData.user.username};

    final results = await conn.execute(query, param);

    final columnName = followType == 'Followers' 
      ? 'follower' : 'following'; 

    final extractedFollows = ExtractData(rowsData: results).extractStringColumn(columnName);

    return extractedFollows;

  }

}