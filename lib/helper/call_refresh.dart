import 'package:get_it/get_it.dart';
import 'package:revent/helper/setup/profile_data_setup.dart';
import 'package:revent/helper/setup/profile_posts_setup.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/provider/profile/profile_saved_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent/vent_comment_provider.dart';
import 'package:revent/provider/vent/vent_for_you_provider.dart';
import 'package:revent/provider/vent/vent_following_data_provider.dart';
import 'package:revent/helper/setup/vent_comment_setup.dart';
import 'package:revent/helper/setup/vent_data_setup.dart';

class CallRefresh {

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> refreshVents() async {

    GetIt.instance<VentForYouProvider>().deleteVentsData();

    await VentDataSetup().setupForYou();

  }

  Future<void> refreshFollowingVents() async {

    GetIt.instance<VentFollowingDataProvider>().deleteVentsData();

    await VentDataSetup().setupFollowing();

  }

  Future<void> refreshMyProfile() async {

    final profileData = GetIt.instance<ProfileDataProvider>();
    final profilePostsData = GetIt.instance<ProfilePostsProvider>();
    final profileSavedData = GetIt.instance<ProfileSavedProvider>();

    profileData.clearProfileData();

    await ProfileDataSetup().setup(username: userData.user.username);

    final callProfilePosts = ProfilePostsSetup(
      userType: 'my_profile', 
      username: userData.user.username
    );

    profilePostsData.myProfile.clear();
    profileSavedData.myProfile.clear();

    await callProfilePosts.setupPosts();
    await callProfilePosts.setupSaved();

  }

  Future<void> refreshVentPost({
    required String title, 
    required String creator
  }) async {

    GetIt.instance<VentCommentProvider>().deleteComments();

    await VentCommentSetup().setup(
      title: title, creator: creator
    );

  }

}