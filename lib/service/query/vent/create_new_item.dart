import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/main.dart';
import 'package:revent/helper/format/format_date.dart';
import 'package:revent/shared/provider/vent/vent_latest_provider.dart';

class CreateNewItem with UserProfileProviderService {

  final String title;
  final String body;
  final String tags;

  CreateNewItem({
    required this.title, 
    required this.body,
    required this.tags
  });

  Future<Map<String, dynamic>> newVent({
    required bool markedNsfw,
    required bool allowCommenting,
  }) async {

    final response = await ApiClient.post(ApiPath.createDefaultVent, {
      'creator': userProvider.user.username,
      'title': title,
      'body_text': body,
      'tags': tags,
      'marked_nsfw': markedNsfw,
      'comment_enabled': allowCommenting,
    });

    if (response.statusCode == 201) {
      
      final postId = response.body!['post_id'] as int;

      _addVent(postId: postId, markedNsfw: markedNsfw);

    }

    return {
      'status_code': response.statusCode
    };

  }

  void _addVent({
    required int postId, 
    required bool markedNsfw
  }) { 

    final formattedTimestamp = FormatDate().formatPostTimestamp(
      DateTime.now()
    );

    final newVent = VentLatestData(
      postId: postId,
      title: title,
      bodyText: markedNsfw ? '' : body, 
      tags: tags,
      isNsfw: markedNsfw,
      creator: userProvider.user.username, 
      postTimestamp: formattedTimestamp, 
      profilePic: getIt.profileProvider.profile.profilePicture,
    );
    
    getIt.ventLatestProvider.addVent(newVent);

  }

  Future<Map<String, dynamic>> newVaultVent() async {

    final response = await ApiClient.post(ApiPath.createVaultVent, {
      'creator': userProvider.user.username,
      'title': title,
      'body_text': body,
      'tags': tags
    });

    return {
      'status_code': response.statusCode
    };

  }

}