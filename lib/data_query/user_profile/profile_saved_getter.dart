import 'dart:convert';

import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/model/format_date.dart';

class ProfileSavedDataGetter {

  final formatPostTimestamp = FormatDate();

  Future<Map<String, List<dynamic>>> getSaved({
    required String username,
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = '''
      SELECT 
        vi.creator,
        vi.title,
        vi.total_likes,
        vi.total_comments,
        vi.created_at,
        upi.profile_picture
      FROM 
        saved_vent_info svi
      JOIN 
        vent_info vi 
        ON svi.title = vi.title AND svi.creator = vi.creator
      JOIN 
        user_profile_info upi
        ON vi.creator = upi.username
      WHERE 
        svi.saved_by = :saved_by
    ''';

    final param = {
      'saved_by': username,
    };

    final retrievedInfo = await conn.execute(query, param);

    final extractData = ExtractData(rowsData: retrievedInfo);
    
    final creator = extractData.extractStringColumn('creator');
    final titles = extractData.extractStringColumn('title');

    final totalComments = extractData.extractIntColumn('total_comments');
    final totalLikes = extractData.extractIntColumn('total_likes');

    final postTimestamp = extractData
      .extractStringColumn('created_at')
      .map((timestamp) => formatPostTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    final profilePicture = extractData
      .extractStringColumn('profile_picture')
      .map((pfpBase64) => base64Decode(pfpBase64))
      .toList();

    return {
      'creator': creator,
      'title': titles,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'post_timestamp': postTimestamp,
      'profile_picture': profilePicture
    };

  }

}