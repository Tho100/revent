import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class DeleteVaultVent extends BaseQueryService {
  
  final int postId;

  DeleteVaultVent({required this.postId});

  Future<Map<String, dynamic>> delete() async {

    final response = await ApiClient.deleteById(ApiPath.deleteVaultVent, postId);

    return {
      'status_code': response.statusCode
    };

  }

}