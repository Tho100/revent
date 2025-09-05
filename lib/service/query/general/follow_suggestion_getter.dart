import 'package:revent/global/table_names.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/data_converter.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class FollowSuggestionGetter extends BaseQueryService with UserProfileProviderService {

  /// Fetch 5 follow suggestions based on the following logic:
  /// If the current user has followed someone, suggest users that those followed users are also following (excluding already followed users).
  /// Otherwise, suggest the 5 most popular users based on follower count.

  Future<Map<String, dynamic>> getSuggestion() async {

    const query = 
    '''
      WITH friend_of_friend AS (
        SELECT DISTINCT uf2.following AS username
        FROM ${TableNames.userFollowsInfo} uf1
        JOIN ${TableNames.userFollowsInfo} uf2 
          ON uf1.following = uf2.follower
        WHERE uf1.follower = :username
          AND uf2.following NOT IN (
            SELECT following 
            FROM ${TableNames.userFollowsInfo}
            WHERE follower = :username
          )
          AND uf2.following != :username
        LIMIT 5
      ),
      popular_users AS (
        SELECT 
          ufi.following AS username, COUNT(*) AS follower_count
        FROM ${TableNames.userFollowsInfo} ufi
        WHERE 
          ufi.following != :username
        GROUP BY 
          ufi.following
        ORDER BY 
          follower_count DESC
        LIMIT 5
      ),
      combined AS (
        SELECT 
          username, 1 AS priority
        FROM friend_of_friend
        UNION ALL
        SELECT 
          username, 2 AS priority
        FROM popular_users
        WHERE 
          username NOT IN (SELECT username FROM friend_of_friend)
      )
      SELECT 
        upi.username, upi.profile_picture
      FROM combined c
      JOIN ${TableNames.userProfileInfo} upi
        ON c.username = upi.username
      ORDER BY 
        c.priority, RAND()
      LIMIT 5;
    ''';

    final param = {'username': userProvider.user.username};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final usernames = extractedData.extractStringColumn('username');
    
    final profilePictures = DataConverter.convertToPfp(
      extractedData.extractStringColumn('profile_picture')
    );

    return {
      'usernames': usernames,
      'profile_pic': profilePictures
    };

  }

}