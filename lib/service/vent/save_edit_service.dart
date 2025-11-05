import 'package:revent/helper/format/format_date.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class SaveVentEditService with UserProfileProviderService, VentProviderService {

  final int postId;
  final String newBody;

  SaveVentEditService({
    required this.postId,
    required this.newBody,
  });

  final _lastEdit = DateTime.now();

  Future<Map<String, dynamic>> saveDefault() async {

    final response = await ApiClient.post(ApiPath.updateDefaultVent, {
      'post_id': postId,
      'new_body': newBody,
      'last_edit': _lastEdit
    });

    if (response.statusCode == 200) {

      activeVentProvider.setBody(newBody); 

      final formatTimeStamp = FormatDate().formatPostTimestamp(_lastEdit);

      activeVentProvider.setLastEdit(formatTimeStamp);

    }

    return {
      'status_code': response.statusCode
    };

  }

  Future<Map<String, dynamic>> saveVault() async {

    final response = await ApiClient.post(ApiPath.updateVaultVent, {
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

}