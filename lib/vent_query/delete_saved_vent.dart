import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/helper/current_provider.dart';

class DeleteSavedVent {
  
  final String title;
  final String creator;

  DeleteSavedVent({
    required this.title,
    required this.creator
  });

  Future<void> delete() async {

    final conn = await ReventConnection.connect();

    const query = 'DELETE FROM saved_vent_info WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': creator,
    };

    await conn.execute(query, params);

    _removeVent();

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