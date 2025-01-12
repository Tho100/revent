import 'dart:typed_data';

import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/user_profile/profile_posts_getter.dart';
import 'package:revent/service/query/user_profile/profile_saved_getter.dart';

class ProfilePostsSetup {

  final String profileType;
  final String username;

  ProfilePostsSetup({
    required this.profileType,
    required this.username
  });

  Future<void> setupPosts() async {

    final profilePostsData = getIt.profilePostsProvider;

    final isDataEmpty = profileType == 'my_profile' 
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

      profilePostsData.setTitles(profileType, title);
      profilePostsData.setBodyText(profileType, bodyText);
      profilePostsData.setTotalLikes(profileType, totalLikes);
      profilePostsData.setTotalComments(profileType, totalComments);
      profilePostsData.setPostTimestamp(profileType, postTimestamp);
      
      profilePostsData.setIsPostLiked(profileType, isPostLiked);
      profilePostsData.setIsPostSaved(profileType, isPostSaved);

    }

  }

  Future<void> setupSaved() async {

    final profileSavedData = getIt.profileSavedProvider;

    final isDataEmpty = profileType == 'my_profile' 
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

      profileSavedData.setCreator(profileType, creator);
      profileSavedData.setProfilePicture(profileType, profilePicture);

      profileSavedData.setTitles(profileType, title);
      profileSavedData.setBodyText(profileType, bodyText);
      profileSavedData.setTotalLikes(profileType, totalLikes);
      profileSavedData.setTotalComments(profileType, totalComments);
      profileSavedData.setPostTimestamp(profileType, postTimestamp);

      profileSavedData.setIsPostLiked(profileType, isPostLiked);
      profileSavedData.setIsPostSaved(profileType, isPostSaved);

    } 

  }

}