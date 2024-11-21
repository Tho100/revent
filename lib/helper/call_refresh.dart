import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_profile/profile_data_setup.dart';
import 'package:revent/data_query/user_profile/profile_posts_getter.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/profile_posts_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent_comment_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/provider/vent_following_data_provider.dart';
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

  Future<void> refreshMyProfile({required String username}) async {

    final profileData = GetIt.instance<ProfileDataProvider>();
    final profilePostsData = GetIt.instance<ProfilePostsProvider>();

    profileData.clearProfileData();

    await ProfileDataSetup().setup(username: username);

    final getPostsData = await ProfilePostsGetter().getPosts(username: username);

    final title = getPostsData['title'] as List<String>;
    final totalLikes = getPostsData['total_likes'] as List<int>;
    final totalComments = getPostsData['total_comments'] as List<int>;
    final postTimestamp = getPostsData['post_timestamp'] as List<String>;

    profilePostsData.setTitles('my_profile', title);
    profilePostsData.setTotalLikes('my_profile', totalLikes);
    profilePostsData.setTotalComments('my_profile', totalComments);
    profilePostsData.setPostTimestamp('my_profile', postTimestamp);

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