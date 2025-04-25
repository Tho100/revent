import 'dart:typed_data';

import 'package:revent/global/profile_type.dart';
import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/user_profile/profile_posts_getter.dart';
import 'package:revent/service/query/user_profile/profile_saved_getter.dart';

class ProfilePostsSetup with ProfilePostsProviderService {

  final String profileType;
  final String username;

  ProfilePostsSetup({
    required this.profileType,
    required this.username
  });

  bool _isDataEmpty(String type) {

    final isMyProfile = profileType == ProfileType.myProfile.value;

    if(type == 'posts') {

      return isMyProfile 
        ? profilePostsProvider.myProfile.titles.isEmpty 
        : profilePostsProvider.userProfile.titles.isEmpty; 

    } else if (type == 'saved') {

      return isMyProfile 
        ? profileSavedProvider.myProfile.titles.isEmpty 
        : profileSavedProvider.userProfile.titles.isEmpty; 
 
    }

    return true;

  }

  Future<void> setupPosts() async {

    final isDataEmpty = _isDataEmpty('posts');

    if(isDataEmpty) {

      final getPostsData = await ProfilePostsDataGetter().getPosts(
        username: username
      );

      final title = getPostsData['title'] as List<String>;
      final bodyText = getPostsData['body_text'] as List<String>;
      final tags = getPostsData['tags'] as List<String>;

      final totalLikes = getPostsData['total_likes'] as List<int>;
      final totalComments = getPostsData['total_comments'] as List<int>;

      final postTimestamp = getPostsData['post_timestamp'] as List<String>;
      
      final isNsfw = getPostsData['is_nsfw'] as List<bool>;
      final isPostLiked = getPostsData['is_liked'] as List<bool>;
      final isPostSaved = getPostsData['is_saved'] as List<bool>;

      profilePostsProvider.setTitles(profileType, title);
      profilePostsProvider.setBodyText(profileType, bodyText);
      profilePostsProvider.setTags(profileType, tags);
      profilePostsProvider.setTotalLikes(profileType, totalLikes);
      profilePostsProvider.setTotalComments(profileType, totalComments);
      profilePostsProvider.setPostTimestamp(profileType, postTimestamp);

      profilePostsProvider.setIsNsfw(profileType, isNsfw);
      profilePostsProvider.setIsPostLiked(profileType, isPostLiked);
      profilePostsProvider.setIsPostSaved(profileType, isPostSaved);

    }

  }

  Future<void> setupSaved() async {

    final isDataEmpty = _isDataEmpty('saved');

    if(isDataEmpty) {

      final getPostsData = await ProfileSavedDataGetter().getSaved(
        username: username, isMyProfile: profileType == ProfileType.myProfile.value
      );

      final creator = getPostsData['creator'] as List<String>;
      final profilePicture = getPostsData['profile_picture'] as List<Uint8List>;

      final title = getPostsData['title'] as List<String>;
      final bodyText = getPostsData['body_text'] as List<String>;
      final tags = getPostsData['tags'] as List<String>;

      final totalLikes = getPostsData['total_likes'] as List<int>;
      final totalComments = getPostsData['total_comments'] as List<int>;

      final postTimestamp = getPostsData['post_timestamp'] as List<String>;

      final isNsfw = getPostsData['is_nsfw'] as List<bool>;
      final isPostLiked = getPostsData['is_liked'] as List<bool>;
      final isPostSaved = getPostsData['is_saved'] as List<bool>;

      profileSavedProvider.setCreator(profileType, creator);
      profileSavedProvider.setProfilePicture(profileType, profilePicture);

      profileSavedProvider.setTitles(profileType, title);
      profileSavedProvider.setBodyText(profileType, bodyText);
      profileSavedProvider.setTags(profileType, tags);
      profileSavedProvider.setTotalLikes(profileType, totalLikes);
      profileSavedProvider.setTotalComments(profileType, totalComments);
      profileSavedProvider.setPostTimestamp(profileType, postTimestamp);
      
      profileSavedProvider.setIsNsfw(profileType, isNsfw);
      profileSavedProvider.setIsPostLiked(profileType, isPostLiked);
      profileSavedProvider.setIsPostSaved(profileType, isPostSaved);

    } 

  }

}