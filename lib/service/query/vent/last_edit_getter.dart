import 'package:revent/global/vent_type.dart';
import 'package:revent/helper/format/format_date.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class LastEditGetter extends BaseQueryService with VentProviderService {

  Future<String> _getLastEdit({required VentType type}) async {

    final response = await ApiClient.get(
      type == VentType.nonVault ? ApiPath.ventLastEditDefaultGetter : ApiPath.ventLastEditVaultGetter, 
      activeVentProvider.ventData.postId
    );

    final lastEdit = response.body!['last_edit'] as String;

    if (lastEdit.isEmpty) {
      return '';
    }

    final formattedTimeStamp = FormatDate().formatPostTimestamp(
      DateTime.parse(lastEdit)
    ); 

    return formattedTimeStamp;

  }

  Future<String> getLastEdit() async => await _getLastEdit(type: VentType.nonVault);
  Future<String> getLastEditVault() async => await _getLastEdit(type: VentType.vault);

}