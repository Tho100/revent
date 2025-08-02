import 'package:revent/helper/data_converter.dart';
import 'package:revent/service/query/user/user_privacy_actions.dart';

class UserPrivacyHandler {

  final privacyActions = UserPrivacyActions();

  static const _privatedProfile = 'privated_profile';
  static const _privatedFollowingList = 'privated_following_list';
  static const _privatedSavedVents = 'privated_saved_vents'; 

  Future<void> privateAccount({required bool makePrivate}) async {
    await privacyActions.updatePrivacyOption(
      value: DataConverter.convertBoolToInt(makePrivate), column: _privatedProfile
    );
  }
  
  Future<void> hideFollowingList({required bool hideFollowingList}) async {
    await privacyActions.updatePrivacyOption(
      value: DataConverter.convertBoolToInt(hideFollowingList), column: _privatedFollowingList
    );
  }

  Future<void> hideSavedPosts({required bool hideSavedPosts}) async {
    await privacyActions.updatePrivacyOption(
      value: DataConverter.convertBoolToInt(hideSavedPosts), column: _privatedSavedVents
    );
  }

}