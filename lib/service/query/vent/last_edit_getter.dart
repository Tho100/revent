import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class LastEditGetter extends BaseQueryService {

  final String title;
  final String creator;

  LastEditGetter({
    required this.title, 
    required this.creator
  });

  Future<String> getLastEdit() async {
    return await _getLastEdit(isFromArchive: false);
  }

  Future<String> getLastEditArchive() async {
    return await _getLastEdit(isFromArchive: true);
  }

  Future<String> _getLastEdit({required bool isFromArchive}) async {

    final query = isFromArchive 
      ? 'SELECT last_edit FROM archive_vent_info WHERE title = :title AND creator = :creator'
      : 'SELECT last_edit FROM vent_info WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': creator
    };

    final results = await executeQuery(query, params);

    if(results.rows.isEmpty || results.rows.last.assoc()['last_edit'] == null) {
      return '';
    }

    final lastEditTimeStamp = results.rows.last.assoc()['last_edit']!;

    final formattedTimeStamp = FormatDate().formatPostTimestamp(DateTime.parse(lastEditTimeStamp));

    return formattedTimeStamp;

  }

}