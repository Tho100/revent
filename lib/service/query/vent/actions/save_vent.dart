import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class SaveVent with UserProfileProviderService {

  final Map<String, dynamic> ventProvider;
  final int postId;

  SaveVent({
    required this.ventProvider, 
    required this.postId
  });

  Future<Map<String, dynamic>> toggleSavePost() async {

    final response = await ApiClient.post(ApiPath.saveVent, {
      'post_id': postId,
      'saved_by': userProvider.user.username
    });

    if (response.statusCode == 200) {
      _updatePostSavedValue(saved: response.body!['saved']);
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _updatePostSavedValue({required bool saved}) {

    final index = ventProvider['vent_index'];
    final ventData = ventProvider['vent_data'];

    ventData.saveVent(index, saved);

  }

}