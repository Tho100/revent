import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/vent/comment/comment_settings.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';

class CreateNewItem extends BaseQueryService with UserProfileProviderService, TagsProviderService {

  final String title;
  final String body;

  CreateNewItem({
    required this.title, 
    required this.body
  });

  Future<void> newVent({
    required String ventTags,
    required bool commentDisabled,
    required bool markedNsfw
  }) async {

    await _insertVentInfo(
      ventTags: ventTags, 
      markedNsfw: markedNsfw
    ).then(
      (_) async => await _updateTotalPosts()
    );

    if(commentDisabled) { // TODO: Remove this and manually set the value to commentDisabled
      await CommentSettings().toggleComment(isEnableComment: 0);
    }
    
    _addVent(
      ventTags: ventTags,
      markedNsfw: markedNsfw
    );

  }

  Future<void> _insertVentInfo({
    required String ventTags,
    required bool markedNsfw
  }) async {

    const insertVentInfoQuery = 
      'INSERT INTO vent_info (creator, title, body_text, tags, total_likes, total_comments, marked_nsfw) VALUES (:creator, :title, :body_text, :tags, :total_likes, :total_comments, :marked_nsfw)';

    final params = {
      'creator': userProvider.user.username,
      'title': title,
      'body_text': body,
      'tags': ventTags,
      'marked_nsfw': markedNsfw,
      'total_likes': 0,
      'total_comments': 0,
    };

    await executeQuery(insertVentInfoQuery, params);

  }

  Future<void> _updateTotalPosts() async {

    const updateTotalPostsQuery = 
      'UPDATE user_profile_info SET posts = posts + 1 WHERE username = :username';

    final param = {'username': userProvider.user.username};

    await executeQuery(updateTotalPostsQuery, param);

  }

  void _addVent({
    required String ventTags,
    required bool markedNsfw
  }) {

    final formattedTimestamp = FormatDate().formatPostTimestamp(DateTime.now());

    final newVent = VentForYouData(
      title: title, 
      bodyText: body, 
      tags: ventTags,
      isNsfw: markedNsfw,
      creator: userProvider.user.username, 
      postTimestamp: formattedTimestamp, 
      profilePic: getIt.profileProvider.profile.profilePicture,
    );
    
    getIt.ventForYouProvider.addVent(newVent);

  }

  Future<void> newArchiveVent() async {

    const insertVentInfoQuery = 'INSERT INTO archive_vent_info (creator, title, body_text) VALUES (:creator, :title, :body_text)';

    final params = {
      'creator': userProvider.user.username,
      'title': title,
      'body_text': body
    };

    await executeQuery(insertVentInfoQuery, params);

  }

}