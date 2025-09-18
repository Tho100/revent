import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/current_provider_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class DeleteVent extends BaseQueryService with UserProfileProviderService, VentProviderService {
// TODO: Replace title with postId
  final String title;

  DeleteVent({required this.title});

  Future<Map<String, int>> delete() async {

    final postId = activeVentProvider.ventData.postId != 0 
      ? activeVentProvider.ventData.postId 
      : await PostIdGetter(title: title, creator: userProvider.user.username).getPostId();

    final response = await ApiClient.deleteById(ApiPath.deleteVent, postId);

    if (response.statusCode == 204) {
      _removeVent();
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _removeVent() {

    final currentProvider = CurrentProviderService(
      title: title, 
      creator: userProvider.user.username
    ).getProvider();

    final ventIndex = currentProvider['vent_index'];    
    final ventData = currentProvider['vent_data'];    

    if (ventIndex != -1) {
      ventData.deleteVent(ventIndex);
    }

  }

}