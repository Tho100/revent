import 'package:revent/global/table_names.dart';
import 'package:revent/helper/format/format_date.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class SaveVentEdit extends BaseQueryService with UserProfileProviderService, VentProviderService {

  final int postId;
  final String newBody;

  SaveVentEdit({
    required this.postId,
    required this.newBody,
  });

  final _lastEdit = DateTime.now();

  Future<Map<String, dynamic>> save() async {

    final response = await ApiClient.post(ApiPath.updateDefaultVent, {
      'post_id': postId,
      'new_body': newBody,
      'last_edit': _lastEdit
    });

    if (response.statusCode == 200) {
      activeVentProvider.setBody(newBody); 
    }

    return {
      'status_code': response.statusCode
    };

  }

  Future<void> saveVault() async {

    const query = 
      'UPDATE ${TableNames.vaultVentInfo} SET body_text = :new_body WHERE post_id = :post_id';

    final params = {
      'post_id': postId,
      'new_body': newBody
    };

    await executeQuery(query, params).then(
      (_) => _updateLastEdit(isFromVault: true)
    );

    activeVentProvider.setBody(newBody);

  }

  Future<void> _updateLastEdit({required bool isFromVault, int? postId}) async {

    final dateTimeNow = DateTime.now();

    final query = isFromVault 
      ? 'UPDATE ${TableNames.vaultVentInfo} SET last_edit = :last_edit WHERE post_id = :post_id'
      : 'UPDATE ${TableNames.ventInfo} SET last_edit = :last_edit WHERE post_id = :post_id';

    final params = isFromVault 
      ? {
        'post_id': postId,
        'last_edit': dateTimeNow
        } 
      : {
        'post_id': postId,
        'last_edit': dateTimeNow
        };

    await executeQuery(query, params);

    final formatTimeStamp = FormatDate().formatPostTimestamp(dateTimeNow);

    if (!isFromVault) {
      activeVentProvider.setLastEdit(formatTimeStamp);
    }

  }

}