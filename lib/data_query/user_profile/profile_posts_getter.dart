import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';

class ProfilePostsGetter {

  Future<List<String>> getPosts({
    required String username
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'SELECT title FROM vent_info WHERE creator = :username';
    final param = {
      'username': username
    };

    final retrievedInfo = await conn.execute(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);

    return extractData.extractStringColumn('title');

  }

}