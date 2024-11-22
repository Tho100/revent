import 'package:get_it/get_it.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/model/format_date.dart';
import 'package:revent/provider/user_data_provider.dart';

class VentDataGetter {

  final formatPostTimestamp = FormatDate();

  final userData = GetIt.instance<UserDataProvider>();

  Future<Map<String, dynamic>> getVentsData() async {

    final conn = await ReventConnect.initializeConnection();

    const query = 'SELECT title, body_text, creator, created_at, total_likes, total_comments FROM vent_info';
    
    final retrievedVents = await conn.execute(query);

    final extractedData = ExtractData(rowsData: retrievedVents);

    final title = extractedData.extractStringColumn('title');
    final bodyText = extractedData.extractStringColumn('body_text');
    final creator = extractedData.extractStringColumn('creator');

    final totalLikes = extractedData.extractIntColumn('total_likes');
    final totalComments = extractedData.extractIntColumn('total_comments');

    final postTimestamp = extractedData
      .extractStringColumn('created_at')
      .map((timestamp) => formatPostTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    final isLikedState = await _ventPostLikedState(
      conn: conn,
      title: title,
    );

    return {
      'title': title,
      'body_text': bodyText,
      'creator': creator,
      'post_timestamp': postTimestamp,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'is_liked': isLikedState
    };

  }

  Future<Map<String, dynamic>> getFollowingVentsData() async {

    final conn = await ReventConnect.initializeConnection();

    const getFollowingQuery = 
    '''
      SELECT v.title, v.body_text, v.creator, v.created_at, v.total_likes, v.total_comments
      FROM vent_info v
      INNER JOIN user_follows_info u ON u.following = v.creator
      WHERE u.follower = :follower
    ''';

    final followingParam = {'follower': userData.user.username};
    
    final followingResults = await conn.execute(getFollowingQuery, followingParam);

    final extractedData = ExtractData(rowsData: followingResults);

    final title = extractedData.extractStringColumn('title');
    final bodyText = extractedData.extractStringColumn('body_text');
    final creator = extractedData.extractStringColumn('creator');
    final totalLikes = extractedData.extractIntColumn('total_likes');
    final totalComments = extractedData.extractIntColumn('total_comments');
    
    final postTimestamp = extractedData
      .extractStringColumn('created_at')
      .map((timestamp) => formatPostTimestamp.formatPostTimestamp(DateTime.parse(timestamp)))
      .toList();

    final isLikedState = await _ventPostLikedState(
      conn: conn,
      title: title,
    );

    return {
      'title': title,
      'body_text': bodyText,
      'creator': creator,
      'post_timestamp': postTimestamp,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'is_liked': isLikedState
    };

  }

  Future<Map<String, dynamic>> getProfilePostsVentData({
    required String title,
    required String creator
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 
      'SELECT body_text FROM vent_info WHERE title = :title AND creator = :creator';
      
    final params = {
      'title': title,
      'creator': creator
    };

    final results = await conn.execute(query, params);

    final extractData = ExtractData(rowsData: results);

    final bodyText = extractData.extractStringColumn('body_text')[0];
       
    return {
      'body_text': bodyText,
    };

  }

  Future<Map<String, dynamic>> getArchiveVentData({
    required String title,
    required String creator
  }) async {

    final conn = await ReventConnect.initializeConnection();

    const query = 
      'SELECT body_text FROM archive_vent_info WHERE title = :title AND creator = :creator';
      
    final params = {
      'title': title,
      'creator': creator
    };

    final results = await conn.execute(query, params);

    final extractData = ExtractData(rowsData: results);

    final bodyText = extractData.extractStringColumn('body_text')[0];
       
    return {
      'body_text': bodyText,
    };

  }

  Future<List<bool>> _ventPostLikedState({
    required MySQLConnectionPool conn,
    required List<String> title,
  }) async {

    const readLikesQuery = 'SELECT title FROM vent_likes_info WHERE liked_by = :liked_by';

    final params = {
      'liked_by': userData.user.username,
    };

    final retrievedTitles = await conn.execute(readLikesQuery, params);

    final extractTitlesData = ExtractData(rowsData: retrievedTitles);

    final likedPostTitle = extractTitlesData.extractStringColumn('title');
    
    final likedTitlesSet = Set<String>.from(likedPostTitle);

    return title.map((t) => likedTitlesSet.contains(t)).toList();

  }

}