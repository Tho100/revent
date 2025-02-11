import 'package:revent/helper/providers_service.dart';
import 'package:revent/model/setup/profile_data_setup.dart';
import 'package:revent/model/setup/profile_posts_setup.dart';
import 'package:revent/model/setup/replies_setup.dart';
import 'package:revent/model/setup/comments_setup.dart';
import 'package:revent/model/setup/vent_data_setup.dart';

class RefreshService with 
  VentProviderService, 
  UserProfileProviderService, 
  ProfilePostsProviderService {

  Future<void> _refreshVentsData({
    required dynamic ventProvider,
    required Future<void> Function() setupMethod,
  }) async {
    ventProvider.deleteVentsData();
    await setupMethod();
  }

  Future<void> refreshForYouVents() async {
    await _refreshVentsData(
      ventProvider: forYouVentProvider,
      setupMethod: () => VentDataSetup().setupForYou(),
    );
  }

  Future<void> refreshTrendingVents() async {
    await _refreshVentsData(
      ventProvider: trendingVentProvider,
      setupMethod: () => VentDataSetup().setupTrending(),
    );
  }

  Future<void> refreshFollowingVents() async {
    await _refreshVentsData(
      ventProvider: followingVentProvider,
      setupMethod: () => VentDataSetup().setupFollowing(),
    );
  }

  Future<void> refreshMyProfile() async {

    profileProvider.clearProfileData();

    final userData = userProvider.user;

    await ProfileDataSetup().setup(username: userData.username);

    final callProfilePosts = ProfilePostsSetup(
      profileType: 'my_profile', 
      username: userData.username
    );

    profilePostsProvider.myProfile.clear();
    profileSavedProvider.myProfile.clear();

    await callProfilePosts.setupPosts();
    await callProfilePosts.setupSaved();

  }

  Future<void> refreshVentPost() async {

    ventCommentProvider.deleteComments();

    await CommentsSetup().setup();

  }

  Future<void> refreshReplies({required int commentId}) async {

    commentRepliesProvider.deleteReplies();

    await RepliesSetup().setup(commentId: commentId);

  }

}