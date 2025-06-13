import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class NewFollowerNotificationGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, List<String>>> getFollowers() async {

    const query = 'SELECT follower, followed_at FROM user_follows_info WHERE following = :username';

    final param = {'username': userProvider.user.username};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final followers = extractedData.extractStringColumn('follower');

    final followedAt = FormatDate().formatToPostDate(
      data: extractedData, columnName: 'followed_at'
    );

    return {
      'followers': followers,
      'followed_at': followedAt
    };

  }

}