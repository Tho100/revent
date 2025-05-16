import 'package:revent/service/query/user/user_privacy_actions.dart';

class UserPrivacyHandler {

  final privacyActions = UserPrivacyActions();

  Future<void> privateAccount({required int isMakePrivate}) async {
    await privacyActions.updatePrivacyData(
      value: isMakePrivate, column: 'privated_profile'
    );
  }
  
  Future<void> hideFollowingList({required int isHideFollowingList}) async {
    await privacyActions.updatePrivacyData(
      value: isHideFollowingList, column: 'privated_following_list'
    );
  }

  Future<void> hideSavedPosts({required int isHideSavedPosts}) async {
    await privacyActions.updatePrivacyData(
      value: isHideSavedPosts, column: 'privated_saved_vents'
    );
  }

}