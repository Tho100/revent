import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';

class DeleteVaultVent {
  
  final int postId;

  DeleteVaultVent({required this.postId});

  Future<Map<String, dynamic>> delete() async {

    final response = await ApiClient.deleteById(ApiPath.deleteVaultVent, postId);

    return {
      'status_code': response.statusCode
    };

  }

}