import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/current_provider_service.dart';

class DeleteVent with UserProfileProviderService, VentProviderService {

  final int postId;

  DeleteVent({required this.postId});

  Future<Map<String, int>> deletePost() async {

    final response = await ApiClient.deleteById(ApiPath.deleteVent, postId);

    if (response.statusCode == 204) {
      _removeVent();
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _removeVent() {

    final currentProvider = CurrentProviderService(postId: postId).getProvider();

    final ventIndex = currentProvider['vent_index'];    
    final ventData = currentProvider['vent_data'];    

    if (ventIndex != -1) {
      ventData.deleteVent(ventIndex);
    }

  }

}