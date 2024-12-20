import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';

class VentCommentsSettings extends BaseQueryService {

  final userData = getIt.userProvider;

  Future<void> toggleComment({
    required String title,
    required int isEnableComment,
  }) async {

    const query = 
      'UPDATE vent_info SET comment_enabled = :new_value WHERE creator = :creator AND title = :title';

    final param = {
      'creator': userData.user.username,
      'title': title,
      'new_value': isEnableComment
    };

    await executeQuery(query, param);

  }
  
  Future<Map<String, int>> getCurrentOptions({
    required String title, 
    required String creator
  }) async {

    const query = 
      'SELECT comment_enabled FROM vent_info WHERE creator = :creator AND title = :title';

    final param = {
      'title': title,
      'creator': creator
    };

    final results = await executeQuery(query, param);

    final extractedData = ExtractData(rowsData: results);

    final commentEnabled = extractedData.extractIntColumn('comment_enabled')[0];

    return {
      'comment_enabled': commentEnabled,
    };

  }

}