import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/current_provider_service.dart';
import 'package:revent/service/query/general/post_id_getter.dart';

class DeleteSavedVent extends BaseQueryService {
  
  final String title;
  final String creator;

  DeleteSavedVent({
    required this.title,
    required this.creator
  });

  Future<void> delete() async {

    final postId = await PostIdGetter(title: title, creator: creator).getPostId();

    const query = 'DELETE FROM saved_vent_info WHERE post_id = :post_id';

    final param = {'post_id': postId};

    await executeQuery(query, param).then(
      (_) => _removeVent()
    );

  }

  void _removeVent() {

    final currentProvider = CurrentProviderService(
      title: title, 
      creator: creator
    ).getProvider();

    final ventIndex = currentProvider['vent_index'];    
    final ventData = currentProvider['vent_data'];    

    if (ventIndex != -1) {
      ventData.deleteVent(ventIndex);
    }

  }

}