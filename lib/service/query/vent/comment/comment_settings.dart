import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class CommentSettings extends BaseQueryService with VentProviderService {

  Future<void> toggleComment({required int isEnableComment}) async {

    const query = 
      'UPDATE vent_info SET comment_enabled = :new_value WHERE post_id = :post_id';

    final param = {
      'post_id': activeVentProvider.ventData.postId,
      'new_value': isEnableComment
    };

    await executeQuery(query, param);

  }
  
  Future<Map<String, int>> getCurrentOptions() async {

    const query = 
      'SELECT comment_enabled FROM vent_info WHERE post_id = :post_id';

    final param = {'post_id': activeVentProvider.ventData.postId};

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final commentEnabled = extractedData.extractIntColumn('comment_enabled')[0];

    return {
      'comment_enabled': commentEnabled,
    };

  }

}