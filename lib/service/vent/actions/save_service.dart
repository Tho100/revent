import 'package:flutter/services.dart';
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

    final index = ventProvider['vent_index'];
    final ventData = ventProvider['vent_data'];

    final isSaved = ventData.vents[index].isPostSaved;

    if (response.statusCode == 200) {
      _updatePostSavedValue(ventData, index, !isSaved);
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _updatePostSavedValue(dynamic ventData, int index, bool doSave) {

    if (doSave) {
      HapticFeedback.heavyImpact();
    }

    ventData.saveVent(index, doSave);

  }

}