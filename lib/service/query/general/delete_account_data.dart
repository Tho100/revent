import 'package:revent/global/table_names.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class DeleteAccountData extends BaseQueryService {

  /// Delete all stored information for [username] on account deletion
  /// including non-archived/archived posts, comments, pinned-comment, etc.

  Future<void> delete({required String username}) async {

    const query = 
    '''
      DELETE ui, upi, upvi, ufi, usl, vi, svi, avi, lvi, ci, cli, cri, rli, pci, pvi
      FROM ${TableNames.userInfo} ui
        LEFT JOIN ${TableNames.userProfileInfo} upi ON upi.username = ui.username
        LEFT JOIN ${TableNames.userPrivacyInfo} pvi ON upvi.username = ui.username
        LEFT JOIN ${TableNames.userFollowsInfo} ufi ON ufi.follower = ui.username
        LEFT JOIN ${TableNames.userSocialLinks} usl ON ufi.username = ui.username
        LEFT JOIN ${TableNames.ventInfo} vi ON vi.creator = ui.username
        LEFT JOIN ${TableNames.savedVentInfo} svi ON svi.creator = ui.username
        LEFT JOIN ${TableNames.archiveVentInfo} avi ON avi.creator = ui.username
        LEFT JOIN ${TableNames.likedVentInfo} lvi ON lvi.liked_by = ui.username
        LEFT JOIN ${TableNames.commentsInfo} ci ON ci.commented_by = ui.username
        LEFT JOIN ${TableNames.commentsLikesInfo} cli ON cli.liked_by = ui.username
        LEFT JOIN ${TableNames.commentRepliesInfo} cri ON cri.replied_by = ui.username
        LEFT JOIN ${TableNames.repliesLikesInfo} rli ON rli.liked_by = ui.username
        LEFT JOIN ${TableNames.pinnedCommentsInfo} pci ON pci.pinned_by = ui.username
        LEFT JOIN ${TableNames.pinnedVentInfo} pvi ON pvi.pinned_by = ui.username
      WHERE ui.username = :username
    ''';

    final param = {'username': username};

    await executeQuery(query, param);

  }

}