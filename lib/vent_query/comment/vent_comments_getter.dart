import 'dart:convert';

import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';

class VentCommentsGetter {

  final String title;
  final String creator;

  VentCommentsGetter({
    required this.title,
    required this.creator
  });

  Future<Map<String, List<dynamic>>> getComments() async {

    final conn = await ReventConnect.initializeConnection();

    const getCommentsQuery = '''
      SELECT vent_comments_info.comment, 
            vent_comments_info.commented_by, 
            user_profile_info.profile_picture 
      FROM vent_comments_info 
      JOIN user_profile_info 
      ON vent_comments_info.commented_by = user_profile_info.username 
      WHERE vent_comments_info.title = :title 
        AND vent_comments_info.creator = :creator
    ''';

    final params = {
      'title': title,
      'creator': creator,
    };

    final results = await conn.execute(getCommentsQuery, params);

    final extractedData = ExtractData(rowsData: results);

    final comment = extractedData.extractStringColumn('comment');
    final commentedBy = extractedData.extractStringColumn('commented_by');
    final profilePictures = extractedData.extractStringColumn('profile_picture')
      .map((pfp) => base64Decode(pfp))
      .toList();

    return {
      'commented_by': commentedBy,
      'comment': comment,
      'profile_picture': profilePictures
    };

  }

}