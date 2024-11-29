import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_profile/profile_data_setup.dart';
import 'package:revent/data_query/user_profile/profile_posts_setup.dart';
import 'package:revent/provider/profile/profile_data_provider.dart';
import 'package:revent/provider/profile/profile_posts_provider.dart';
import 'package:revent/provider/profile/profile_saved_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent/vent_comment_provider.dart';
import 'package:revent/provider/vent/vent_data_provider.dart';
import 'package:revent/provider/vent/vent_following_data_provider.dart';
import 'package:revent/vent_query/comment/vent_comment_setup.dart';
import 'package:revent/vent_query/vent_data_setup.dart';

class CallRefresh {

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> refreshVents() async {

    final ventData = GetIt.instance<VentDataProvider>();

    ventData.deleteVentsData();

    await VentDataSetup().setup();

  }

  Future<void> refreshFollowingVents() async {

    final ventData = GetIt.instance<VentFollowingDataProvider>();

    ventData.deleteVentsData();

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

    final ventCommentProvider = GetIt.instance<VentCommentProvider>();

    ventCommentProvider.deleteComments();

    await VentCommentSetup().setup(
      title: title, creator: creator
    );

  }

}