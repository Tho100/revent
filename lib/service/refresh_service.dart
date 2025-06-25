import 'package:revent/global/profile_type.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/model/setup/profile_data_setup.dart';
import 'package:revent/model/setup/profile_posts_setup.dart';
import 'package:revent/model/setup/replies_setup.dart';
import 'package:revent/model/setup/comments_setup.dart';
import 'package:revent/model/setup/vents_setup.dart';

class RefreshService with 
  VentProviderService, 
  UserProfileProviderService, 
  ProfilePostsProviderService,
  CommentsProviderService,
  RepliesProviderService {

  Future<void> _refreshVentsData({
    required dynamic ventProvider,
    required Future<void> Function() setupMethod,
  }) async {
    ventProvider.deleteVentsData();
    await setupMethod();
  }

  Future<void> refreshLatestVents() async {
    await _refreshVentsData(
      ventProvider: latestVentProvider,
      setupMethod: () => VentsSetup().setupLatest(),
    );
  }

  Future<void> refreshTrendingVents() async {
    await _refreshVentsData(
      ventProvider: trendingVentProvider,
      setupMethod: () => VentsSetup().setupTrending(),
    );
  }

  Future<void> refreshFollowingVents() async {
    await _refreshVentsData(
      ventProvider: followingVentProvider,
      setupMethod: () => VentsSetup().setupFollowing(),
    );
  }

  Future<void> refreshMyProfile() async {

    profileProvider.clearProfileData();

    final userData = userProvider.user;

    await ProfileDataSetup().setup(username: userData.username);

    final callProfilePosts = ProfilePostsSetup(
      profileType: ProfileType.myProfile.value,
      username: userData.username
    );

    profilePostsProvider.myProfile.clear();
    profileSavedProvider.myProfile.clear();

    await callProfilePosts.setupPosts();
    await callProfilePosts.setupSaved();

  }

  Future<void> refreshVentPost() async {

    commentsProvider.deleteComments();

    await CommentsSetup().setup();

  }

  Future<void> refreshReplies({required int commentId}) async {

    repliesProvider.deleteReplies();

    await RepliesSetup().setup(commentId: commentId);

  }

}