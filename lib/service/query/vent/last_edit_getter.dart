import 'package:revent/helper/format_date.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class LastEditGetter extends BaseQueryService with VentProviderService {

  Future<String> getLastEdit() async {
    return await _getLastEdit(isFromArchive: false);
  }

  Future<String> getLastEditArchive() async {
    return await _getLastEdit(isFromArchive: true);
  }

  Future<String> _getLastEdit({required bool isFromArchive}) async {

    final query = isFromArchive 
      ? 'SELECT last_edit FROM archive_vent_info WHERE title = :title AND creator = :creator'
      : 'SELECT last_edit FROM vent_info WHERE post_id = :post_id';

    final params = isFromArchive 
      ? {
        'title': activeVentProvider.ventData.title, 
        'creator': activeVentProvider.ventData.creator
        } 
      : {'post_id': activeVentProvider.ventData.postId};

    final results = await executeQuery(query, params);

    if(results.rows.isEmpty || results.rows.last.assoc()['last_edit'] == null) {
      return '';
    }

    final lastEditTimeStamp = results.rows.last.assoc()['last_edit']!;

    final formattedTimeStamp = FormatDate().formatPostTimestamp(DateTime.parse(lastEditTimeStamp));

    return formattedTimeStamp;

  }

}