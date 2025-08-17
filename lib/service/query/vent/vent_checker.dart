import 'package:revent/global/table_names.dart';
import 'package:revent/global/vent_type.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class VentChecker extends BaseQueryService {
  
  final String title;

  VentChecker({required this.title});

  Future<bool> _isVentExists({required VentType type}) async {

    final table = type == VentType.vault 
      ? TableNames.vaultVentInfo : TableNames.ventInfo;

    final query = 'SELECT 1 FROM $table WHERE creator = :creator AND title = :title';

    final param = {
      'title': title,
      'creator': getIt.userProvider.user.username
    };

    final results = await executeQuery(query, param);

    return results.rows.isNotEmpty;

  }

  Future<bool> isVentExists() async => _isVentExists(type: VentType.nonVault);
  Future<bool> isVaultVentExists() async => _isVentExists(type: VentType.vault);
  
}