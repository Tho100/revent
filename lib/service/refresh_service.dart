import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/model/setup/profile_data_setup.dart';
import 'package:revent/model/setup/profile_posts_setup.dart';
import 'package:revent/model/setup/vent_comment_setup.dart';
import 'package:revent/model/setup/vent_data_setup.dart';

class RefreshService {

  final userData = getIt.userProvider;

  Future<void> refreshVents() async {

    getIt.ventForYouProvider.deleteVentsData();

    await VentDataSetup().setupForYou();

  }

  Future<void> refreshTrendingVents() async {

    getIt.ventTrendingProvider.deleteVentsData();

    await VentDataSetup().setupTrending();

  }

  Future<void> refreshFollowingVents() async {

    getIt.ventFollowingProvider.deleteVentsData();

    await VentDataSetup().setupFollowing();

  }

  Future<void> refreshMyProfile() async {

    final profileData = getIt.profileProvider;
    final profilePostsData = getIt.profilePostsProvider;
    final profileSavedData = getIt.profileSavedProvider;

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

    getIt.ventCommentProvider.deleteComments();

    await VentCommentSetup().setup(
      title: title, creator: creator
    );

  }

}