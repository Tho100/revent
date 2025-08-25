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
      setupMethod: () => VentsSetup().setupLatest(), // ToDO: remove () =>
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

    final profilePostsSetup = ProfilePostsSetup(
      profileType: ProfileType.myProfile,
      username: userData.username
    );

    profilePostsProvider.myProfile.clear();
    profileSavedProvider.myProfile.clear();

    await profilePostsSetup.setupPosts();
    await profilePostsSetup.setupSaved();

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