import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class VentChecker extends BaseQueryService {
  
  final String title;

  VentChecker({required this.title});

  Future<bool> isVentExists() async {

    const query = 'SELECT 1 FROM vent_info WHERE creator = :creator AND title = :title';

    final param = {
      'title': title,
      'creator': getIt.userProvider.user.username
    };

    final results = await executeQuery(query, param);

    return results.rows.isNotEmpty;

  }

  Future<bool> isArchivedVentExists() async {

    const query = 'SELECT 1 FROM archive_vent_info WHERE creator = :creator AND title = :title';

    final param = {
      'title': title,
      'creator': getIt.userProvider.user.username
    };

    final results = await executeQuery(query, param);

    return results.rows.isNotEmpty;

  }

}