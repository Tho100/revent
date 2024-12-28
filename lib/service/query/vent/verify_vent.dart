import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class VerifyVent extends BaseQueryService {
  
  final String title;

  VerifyVent({required this.title});

  Future<bool> ventIsAlreadyExists() async {

    const query = 'SELECT * FROM vent_info WHERE creator = :creator AND title = :title';

    final param = {
      'title': title,
      'creator': getIt.userProvider.user.username
    };

    final results = await executeQuery(query, param);

    return results.rows.isNotEmpty;

  }

}