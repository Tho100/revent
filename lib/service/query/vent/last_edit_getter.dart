import 'package:revent/global/table_names.dart';
import 'package:revent/global/vent_type.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class LastEditGetter extends BaseQueryService with VentProviderService {

  Future<String> _getLastEdit({required VentType type}) async {

    final query = type == VentType.archived 
      ? 'SELECT last_edit FROM ${TableNames.archiveVentInfo} WHERE title = :title AND creator = :creator'
      : 'SELECT last_edit FROM ${TableNames.ventInfo} WHERE post_id = :post_id';

    final params = type == VentType.archived
      ? {
        'title': activeVentProvider.ventData.title, 
        'creator': activeVentProvider.ventData.creator
        } 
      : {'post_id': activeVentProvider.ventData.postId};

    final results = await executeQuery(query, params);

    if (results.rows.isEmpty || results.rows.last.assoc()['last_edit'] == null) {
      return '';
    }

    final lastEditTimeStamp = results.rows.last.assoc()['last_edit']!;
    
    final formattedTimeStamp = FormatDate().formatPostTimestamp(
      DateTime.parse(lastEditTimeStamp)
    );

    return formattedTimeStamp;

  }

  Future<String> getLastEdit() async => await _getLastEdit(type: VentType.nonArchived);
  Future<String> getLastEditArchive() async => await _getLastEdit(type: VentType.archived);

}