import 'package:revent/global/table_names.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/service/current_provider_service.dart';

class UnsaveVent extends BaseQueryService {
  
  final int postId;

  UnsaveVent({required this.postId});

  Future<void> unsave() async {

    const query = 'DELETE FROM ${TableNames.savedVentInfo} WHERE post_id = :post_id';

    final param = {'post_id': postId};

    await executeQuery(query, param).then(
      (_) => _removeVent()
    );

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