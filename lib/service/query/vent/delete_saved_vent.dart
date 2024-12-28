import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/current_provider.dart';

class DeleteSavedVent extends BaseQueryService {
  
  final String title;
  final String creator;

  DeleteSavedVent({
    required this.title,
    required this.creator
  });

  Future<void> delete() async {

    const query = 'DELETE FROM saved_vent_info WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': creator,
    };

    await executeQuery(query, params).then(
      (_) => _removeVent()
    );

  }

  void _removeVent() {

    final currentProvider = CurrentProvider(
      title: title, 
      creator: creator
    ).getProvider();

    final ventIndex = currentProvider['vent_index'];    
    final ventData = currentProvider['vent_data'];    

    if(ventIndex != -1) {
      ventData.deleteVent(ventIndex);
    }

  }

}