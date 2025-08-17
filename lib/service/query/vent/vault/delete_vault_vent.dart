import 'package:revent/global/table_names.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class DeleteVaultVent extends BaseQueryService {
  
  final String title;

  DeleteVaultVent({required this.title});

  Future<void> delete() async {

    const query = 'DELETE FROM ${TableNames.vaultVentInfo} WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': getIt.userProvider.user.username,
    };

    await executeQuery(query, params);

  }

}