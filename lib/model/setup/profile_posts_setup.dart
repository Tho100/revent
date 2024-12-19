import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:revent/service/data_query/user_profile/profile_posts_getter.dart';
import 'package:revent/service/data_query/user_profile/profile_saved_getter.dart';
import 'package:revent/shared/provider/profile/profile_posts_provider.dart';
import 'package:revent/shared/provider/profile/profile_saved_provider.dart';

class ProfilePostsSetup {

  final String userType;
  final String username;

  ProfilePostsSetup({
    required this.userType,
    required this.username
  });

  final profilePostsData = GetIt.instance<ProfilePostsProvider>();
  final profileSavedData = GetIt.instance<ProfileSavedProvider>();

  Future<void> setupPosts() async {

    final isDataEmpty = userType == 'my_profile' 
      ? profilePostsData.myProfile.titles.isEmpty 
      : profilePostsData.userProfile.titles.isEmpty;

    if(isDataEmpty) {

      final getPostsData = await ProfilePostsDataGetter().getPosts(
        username: username
      );

      final title = getPostsData['title'] as List<String>;
      final bodyText = getPostsData['body_text'] as List<String>;

      final totalLikes = getPostsData['total_likes'] as List<int>;
      final totalComments = getPostsData['total_comments'] as List<int>;

      final postTimestamp = getPostsData['post_timestamp'] as List<String>;

      final isPostLiked = getPostsData['is_liked'] as List<bool>;
      final isPostSaved = getPostsData['is_saved'] as List<bool>;

      profilePostsData.setTitles(userType, title);
      profilePostsData.setBodyText(userType, bodyText);
      profilePostsData.setTotalLikes(userType, totalLikes);
      profilePostsData.setTotalComments(userType, totalComments);
      profilePostsData.setPostTimestamp(userType, postTimestamp);
      
      profilePostsData.setIsPostLiked(userType, isPostLiked);
      profilePostsData.setIsPostSaved(userType, isPostSaved);

    }

  }

  Future<void> setupSaved() async {

    final isDataEmpty = userType == 'my_profile' 
      ? profileSavedData.myProfile.titles.isEmpty 
      : profileSavedData.userProfile.titles.isEmpty;

    if(isDataEmpty) {

      final getPostsData = await ProfileSavedDataGetter().getSaved(
        username: username
      );

      final creator = getPostsData['creator'] as List<String>;
      final profilePicture = getPostsData['profile_picture'] as List<Uint8List>;

      final title = getPostsData['title'] as List<String>;
      final bodyText = getPostsData['body_text'] as List<String>;

      final totalLikes = getPostsData['total_likes'] as List<int>;
      final totalComments = getPostsData['total_comments'] as List<int>;

      final postTimestamp = getPostsData['post_timestamp'] as List<String>;

      final isPostLiked = getPostsData['is_liked'] as List<bool>;
      final isPostSaved = getPostsData['is_saved'] as List<bool>;

      profileSavedData.setCreator(userType, creator);
      profileSavedData.setProfilePicture(userType, profilePicture);

      profileSavedData.setTitles(userType, title);
      profileSavedData.setBodyText(userType, bodyText);
      profileSavedData.setTotalLikes(userType, totalLikes);
      profileSavedData.setTotalComments(userType, totalComments);
      profileSavedData.setPostTimestamp(userType, postTimestamp);

      profileSavedData.setIsPostLiked(userType, isPostLiked);
      profileSavedData.setIsPostSaved(userType, isPostSaved);

    } 

  }

}