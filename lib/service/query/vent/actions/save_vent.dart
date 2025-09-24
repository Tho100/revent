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

  Future<Map<String, dynamic>> _callSaveRequest() async {

    final response = await ApiClient.post(ApiPath.saveVent, {
      'post_id': postId,
      'saved_by': userProvider.user.username
    });

    return {
      'status_code': response.statusCode
    };

  }

  Future<Map<String, dynamic>> savePost() async {

    final response = await _callSaveRequest();

    if (response['status_code'] == 200) {
      _updatePostSavedValue(isUserSavedPost: true);
    }

    return response;

  }

  Future<Map<String, dynamic>> unsavePost() async {

    final response = await _callSaveRequest();

    if (response['status_code'] == 200) {
      _updatePostSavedValue(isUserSavedPost: false);
    }

    return response;

  }

  void _updatePostSavedValue({required bool isUserSavedPost}) {

    final index = ventProvider['vent_index'];
    final ventData = ventProvider['vent_data'];

    ventData.saveVent(index, isUserSavedPost);

  }

}