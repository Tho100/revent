import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';

class ProfilePostsGetter {

  Future<Map<String, List<dynamic>>> getPosts({
    required String username
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'SELECT title, total_likes FROM vent_info WHERE creator = :username';
    final param = {
      'username': username
    };

    final retrievedInfo = await conn.execute(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);
    
    final title = extractData.extractStringColumn('title');
    final totalLikes = extractData.extractIntColumn('total_likes');

    return {
      'title': title,
      'total_likes': totalLikes
    };

  }

}