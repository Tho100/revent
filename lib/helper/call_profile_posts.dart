import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_profile/profile_posts_getter.dart';
import 'package:revent/data_query/user_profile/profile_saved_getter.dart';
import 'package:revent/provider/profile_posts_provider.dart';
import 'package:revent/provider/profile_saved_provider.dart';

class CallProfilePosts {

  final String userType;
  final String username;

  CallProfilePosts({
    required this.userType,
    required this.username
  });

  final profilePostsData = GetIt.instance<ProfilePostsProvider>();
  final profileSavedData = GetIt.instance<ProfileSavedProvider>();

  Future<void> setPostsData() async {

    final getPostsData = await ProfilePostsDataGetter().getPosts(
      username: username
    );

    final title = getPostsData['title'] as List<String>;
    final totalLikes = getPostsData['total_likes'] as List<int>;
    final totalComments = getPostsData['total_comments'] as List<int>;
    final postTimestamp = getPostsData['post_timestamp'] as List<String>;

    profilePostsData.setTitles(userType, title);
    profilePostsData.setTotalLikes(userType, totalLikes);
    profilePostsData.setTotalComments(userType, totalComments);
    profilePostsData.setPostTimestamp(userType, postTimestamp);

  }

  Future<void> setSavedData() async {

    if(profileSavedData.myProfile.titles.isEmpty) {

      final getPostsData = await ProfileSavedDataGetter().getSaved(
        username: username
      );

      final creator = getPostsData['creator'] as List<String>;
      final profilePicture = getPostsData['profile_picture'] as List<Uint8List>;

      final title = getPostsData['title'] as List<String>;
      final totalLikes = getPostsData['total_likes'] as List<int>;

      final totalComments = getPostsData['total_comments'] as List<int>;
      final postTimestamp = getPostsData['post_timestamp'] as List<String>;

      profileSavedData.setCreator(userType, creator);
      profileSavedData.setProfilePicture(userType, profilePicture);

      profileSavedData.setTitles(userType, title);
      profileSavedData.setTotalLikes(userType, totalLikes);
      profileSavedData.setTotalComments(userType, totalComments);
      profileSavedData.setPostTimestamp(userType, postTimestamp);

    } 

  }

}