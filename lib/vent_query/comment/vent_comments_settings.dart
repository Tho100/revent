import 'package:get_it/get_it.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/model/extract_data.dart';
import 'package:revent/provider/user_data_provider.dart';

class VentCommentsSettings {

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> toggleComment({
    required String title,
    required int isEnableComment,
  }) async {

    final conn = await ReventConnection.connect();

    const query = 
      'UPDATE vent_info SET comment_enabled = :new_value WHERE creator = :creator AND title = :title';

    final param = {
      'creator': userData.user.username,
      'title': title,
      'new_value': isEnableComment
    };

    await conn.execute(query, param);

  }
  
  Future<Map<String, int>> getCurrentOptions({
    required String title, 
    required String creator
  }) async {

    final conn = await ReventConnection.connect();

    const query = 
      'SELECT comment_enabled FROM vent_info WHERE creator = :creator AND title = :title';

    final param = {
      'title': title,
      'creator': creator
    };

    final results = await conn.execute(query, param);

    final extractedData = ExtractData(rowsData: results);

    final commentEnabled = extractedData.extractIntColumn('comment_enabled')[0];

    return {
      'comment_enabled': commentEnabled,
    };

  }

}