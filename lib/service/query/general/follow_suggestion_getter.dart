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
      SELECT u.username, u.profile_picture
      FROM (
        (
          SELECT DISTINCT uf2.following AS username
          ${TableNames.userFollowsInfo} uf1
          JOIN ${TableNames.userFollowsInfo} uf2 
              ON uf1.following = uf2.follower
          WHERE uf1.follower = :username
            AND uf2.following NOT IN (
                SELECT following ${TableNames.userFollowsInfo} WHERE follower = :username
            )
            AND uf2.following != :username
      )
      UNION
      (
        SELECT username
        ${TableNames.userProfileInfo} 
          WHERE username != :username
          GROUP BY username
          ORDER BY COUNT(followers)
        )
      ) AS suggested_users
      JOIN ${TableNames.userProfileInfo} u ON suggested_users.username = u.username
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