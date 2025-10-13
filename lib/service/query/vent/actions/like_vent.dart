import 'package:flutter/services.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class LikeVent with UserProfileProviderService {

  final Map<String, dynamic> ventProvider;
  final int postId;

  LikeVent({
    required this.ventProvider, 
    required this.postId
  });

  Future<Map<String, dynamic>> toggleLikePost() async {

    final response = await ApiClient.post(ApiPath.likeVent, {
      'post_id': postId,
      'liked_by': userProvider.user.username,
    });

    if (response.statusCode == 200) {
      _updatePostLikeValue(liked: response.body!['liked']);
    }

    return {
      'status_code': response.statusCode
    };

  }

  void _updatePostLikeValue({required bool liked}) {

    if (liked) {
      HapticFeedback.heavyImpact();
    }

    final index = ventProvider['vent_index'];
    final ventData = ventProvider['vent_data'];

    ventData.likeVent(index, liked);

  }

}