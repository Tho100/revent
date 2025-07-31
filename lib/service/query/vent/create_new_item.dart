import 'package:revent/global/table_names.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider/vent/vent_latest_provider.dart';

class CreateNewItem extends BaseQueryService with UserProfileProviderService {

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

    await _createVentTransaction(markedNsfw: markedNsfw, allowCommenting: allowCommenting).then(
      (_) => _addVent(markedNsfw: markedNsfw)
    );
    
  }

  Future<void> _createVentTransaction({
    required bool markedNsfw,
    required bool allowCommenting
  }) async {

    final conn = await connection();

    await conn.transactional((txn) async {

      await txn.execute(
        '''
          INSERT INTO ${TableNames.ventInfo} 
            (creator, title, body_text, tags, marked_nsfw, comment_enabled) 
          VALUES 
          (:creator, :title, :body_text, :tags, :marked_nsfw, :comment_enabled)
        ''',
        {
          'creator': userProvider.user.username,
          'title': title,
          'body_text': body,
          'tags': tags,
          'marked_nsfw': markedNsfw,
          'comment_enabled': allowCommenting,
        }
      );

      await txn.execute(
        'UPDATE ${TableNames.userProfileInfo} SET posts = posts + 1 WHERE username = :username',
        {'username': userProvider.user.username}
      );

    });

  }

  void _addVent({required bool markedNsfw}) { 

    final formattedTimestamp = FormatDate().formatPostTimestamp(
      DateTime.now()
    );

    final newVent = VentLatestData(
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

  Future<void> newArchiveVent() async {

    const insertVentInfoQuery = 'INSERT INTO ${TableNames.archiveVentInfo} (creator, title, body_text, tags) VALUES (:creator, :title, :body_text, :tags)';

    final params = {
      'creator': userProvider.user.username,
      'title': title,
      'body_text': body,
      'tags': tags
    };

    await executeQuery(insertVentInfoQuery, params);

  }

}