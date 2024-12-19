import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/format_date.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';

class CreateNewItem extends BaseQueryService {

  final ventData = getIt.ventForYouProvider;
  final userData = getIt.userProvider;
  final profileData = getIt.profileProvider;

  Future<void> newVent({
    required String ventTitle,
    required String ventBodyText,
  }) async {

    await _insertVentInfo(
      ventTitle: ventTitle, ventBodyText: ventBodyText
    ).then(
      (_) async => await _updateTotalPosts()
    );
    
    _addVent(
      ventTitle: ventTitle, 
      ventBodyText: ventBodyText
    );

  }

  Future<void> _insertVentInfo({
    required String ventTitle,
    required String ventBodyText
  }) async {

    const insertVentInfoQuery = 'INSERT INTO vent_info (creator, title, body_text, total_likes, total_comments) VALUES (:creator, :title, :body_text, :total_likes, :total_comments)';

    final params = {
      'creator': userData.user.username,
      'title': ventTitle,
      'body_text': ventBodyText,
      'total_likes': 0,
      'total_comments': 0,
    };

    await executeQuery(insertVentInfoQuery, params);

  }

  Future<void> _updateTotalPosts() async {

    const updateTotalPostsQuery = 
      'UPDATE user_profile_info SET posts = posts + 1 WHERE username = :username';

    final param = {
      'username': userData.user.username
    };

    await executeQuery(updateTotalPostsQuery, param);

  }

  void _addVent({
    required String ventTitle, 
    required String ventBodyText
  }) {

    final now = DateTime.now();
    final formattedTimestamp = FormatDate().formatPostTimestamp(now);

    final newVent = VentForYouData(
      title: ventTitle, 
      bodyText: ventBodyText, 
      creator: userData.user.username, 
      postTimestamp: formattedTimestamp, 
      profilePic: profileData.profilePicture
    );
    
    ventData.addVent(newVent);

  }

  Future<void> newArchiveVent({
    required String ventTitle,
    required String ventBodyText,
  }) async {

    const insertVentInfoQuery = 'INSERT INTO archive_vent_info (creator, title, body_text) VALUES (:creator, :title, :body_text)';

    final params = {
      'creator': userData.user.username,
      'title': ventTitle,
      'body_text': ventBodyText,
    };

    await executeQuery(insertVentInfoQuery, params);

  }

}