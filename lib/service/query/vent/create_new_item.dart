import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider/vent/vent_latest_provider.dart';

class CreateNewItem extends BaseQueryService with UserProfileProviderService, TagsProviderService {

  final String title;
  final String body;
  final String tags;

  CreateNewItem({
    required this.title, 
    required this.body,
    required this.tags
  });

  Future<void> newVent({
    required bool markedNsfw,
    required bool allowCommenting,
  }) async {

    await _insertVentInfo(
      markedNsfw: markedNsfw,
      allowCommenting: allowCommenting
    ).then(
      (_) async => await _updateTotalPosts()
    );
    
    _addVent(markedNsfw: markedNsfw);

  }

  Future<void> _insertVentInfo({
    required bool markedNsfw,
    required bool allowCommenting
  }) async {

    const insertVentInfoQuery = 
      'INSERT INTO vent_info (creator, title, body_text, tags, marked_nsfw, comment_enabled, total_likes, total_comments) VALUES (:creator, :title, :body_text, :tags, :marked_nsfw, :comment_enabled, :total_likes, :total_comments)';

    final params = {
      'creator': userProvider.user.username,
      'title': title,
      'body_text': body,
      'tags': tags,
      'marked_nsfw': markedNsfw,
      'comment_enabled': allowCommenting,
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

  void _addVent({required bool markedNsfw}) { 
    // TODO: Follow formatting convention

    final formattedTimestamp = FormatDate().formatPostTimestamp(DateTime.now());

    final newVent = VentLatestData(
      title: title,
      bodyText: body, 
      tags: tags,
      isNsfw: markedNsfw,
      creator: userProvider.user.username, 
      postTimestamp: formattedTimestamp, 
      profilePic: getIt.profileProvider.profile.profilePicture,
    );
    
    getIt.ventLatestProvider.addVent(newVent);

  }

  Future<void> newArchiveVent() async {

    const insertVentInfoQuery = 'INSERT INTO archive_vent_info (creator, title, body_text, tags) VALUES (:creator, :title, :body_text, :tags)';

    final params = {
      'creator': userProvider.user.username,
      'title': title,
      'body_text': body,
      'tags': tags
    };

    await executeQuery(insertVentInfoQuery, params);

  }

}