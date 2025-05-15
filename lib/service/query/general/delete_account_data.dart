import 'package:revent/service/query/general/base_query_service.dart';

class DeleteAccountData extends BaseQueryService {

  Future<void> delete({required String username}) async {

    const query = '''
      DELETE ui, upi, upvi, ufi, usl, vi, svi, avi, lvi, ci, cli, cri, rli, pci, pvi
      FROM user_information ui
        LEFT JOIN user_profile_info upi ON upi.username = ui.username
        LEFT JOIN user_privacy_info pvi ON upvi.username = ui.username
        LEFT JOIN user_follows_info ufi ON ufi.follower = ui.username
        LEFT JOIN user_social_links usl ON ufi.username = ui.username
        LEFT JOIN vent_info vi ON vi.creator = ui.username
        LEFT JOIN saved_vent_info svi ON svi.creator = ui.username
        LEFT JOIN archive_vent_info avi ON avi.creator = ui.username
        LEFT JOIN liked_vent_info lvi ON lvi.liked_by = ui.username
        LEFT JOIN comments_info ci ON ci.commented_by = ui.username
        LEFT JOIN comments_likes_info cli ON cli.liked_by = ui.username
        LEFT JOIN comment_replies_info cri ON cri.replied_by = ui.username
        LEFT JOIN replies_likes_info rli ON rli.liked_by = ui.username
        LEFT JOIN pinned_comments_info pci ON pci.pinned_by = ui.username
        LEFT JOIN pinned_vent_info pvi ON pvi.pinned_by = ui.username
      WHERE ui.username = :username
    ''';

    final param = {'username': username};

    await executeQuery(query, param);

  }

}