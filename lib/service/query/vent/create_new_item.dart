import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/service/query/vent/comment/comment_settings.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';

class CreateNewItem extends BaseQueryService with UserProfileProviderService, TagsProviderService {

  Future<void> newVent({
    required String ventTitle,
    required String ventBodyText,
    required String ventTags,
    required bool commentDisabled
  }) async {

    await _insertVentInfo(
      ventTitle: ventTitle, ventBodyText: ventBodyText, ventTags: ventTags
    ).then(
      (_) async => await _updateTotalPosts()
    );

    if(commentDisabled) {
      print("IN");
      await CommentSettings().toggleComment(isEnableComment: 0);
    }
    
    _addVent(
      ventTitle: ventTitle, 
      ventTags: ventTags,
      ventBodyText: ventBodyText
    );

  }

  Future<void> _insertVentInfo({
    required String ventTitle,
    required String ventBodyText,
    required String ventTags
  }) async {

    const insertVentInfoQuery = 
      'INSERT INTO vent_info (creator, title, body_text, tags, total_likes, total_comments) VALUES (:creator, :title, :body_text, :tags, :total_likes, :total_comments)';

    final params = {
      'creator': userProvider.user.username,
      'title': ventTitle,
      'body_text': ventBodyText,
      'tags': ventTags,
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
    required String ventTitle, 
    required String ventBodyText,
    required String ventTags
  }) {

    final formattedTimestamp = FormatDate().formatPostTimestamp(DateTime.now());

    final newVent = VentForYouData(
      title: ventTitle, 
      bodyText: ventBodyText, 
      tags: ventTags,
      creator: userProvider.user.username, 
      postTimestamp: formattedTimestamp, 
      profilePic: getIt.profileProvider.profile.profilePicture
    );
    
    getIt.ventForYouProvider.addVent(newVent);

  }

  Future<void> newArchiveVent({
    required String ventTitle,
    required String ventBodyText,
  }) async {

    const insertVentInfoQuery = 'INSERT INTO archive_vent_info (creator, title, body_text) VALUES (:creator, :title, :body_text)';

    final params = {
      'creator': userProvider.user.username,
      'title': ventTitle,
      'body_text': ventBodyText
    };

    await executeQuery(insertVentInfoQuery, params);

  }

}