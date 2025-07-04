import 'package:revent/helper/extract_data.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class VentPostNotificationGetter extends BaseQueryService with UserProfileProviderService {

  Future<Map<String, List<dynamic>>> getPostLikes() async {

    const query = 
    '''
      SELECT 
        vi.title, 
        vi.creator, 
        lvi.liked_at, 
        COUNT(lvi.post_id) AS like_count
      FROM vent_info vi
      INNER JOIN liked_vent_info lvi ON vi.post_id = lvi.post_id 
      WHERE vi.creator = :creator
      GROUP BY vi.post_id 
      HAVING like_count IN (1, 5) OR like_count >= 10
    ''';

    final param = {'creator': userProvider.user.username};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final titles = extractedData.extractStringColumn('title');
    final likeCount = extractedData.extractIntColumn('like_count');

    final likedAt = FormatDate().formatToPostDate(
      data: extractedData, columnName: 'liked_at'
    );

    return {
      'title': titles,
      'like_count': likeCount,
      'liked_at': likedAt
    };

  }

}