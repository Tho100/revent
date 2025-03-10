import 'dart:typed_data';

import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/user_profile/profile_picture_getter.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';
import 'package:revent/service/query/vent/vent_data_getter.dart';
import 'package:revent/shared/provider/vent/vent_for_you_provider.dart';
import 'package:revent/shared/provider/vent/vent_trending_provider.dart';

class VentDataSetup with VentProviderService, SearchProviderService, LikedSavedProviderService {

  Future<dynamic> _ventsData({required Map<String, dynamic> ventsInfo}) async {

    final titles = ventsInfo['title']! as List<String>;
    final bodyText = ventsInfo['body_text']! as List<String>;
    final tags = ventsInfo['tags']! as List<String>;
    final postTimestamp = ventsInfo['post_timestamp']! as List<String>;
    final creator = ventsInfo['creator']! as List<String>;
    final totalLikes = ventsInfo['total_likes']! as List<int>;
    final totalComments = ventsInfo['total_comments']! as List<int>;
    final isLiked = ventsInfo['is_liked']! as List<bool>;
    final isSaved = ventsInfo['is_saved']! as List<bool>;

    final profilePicGetter = ProfilePictureGetter();

    final profilePic = await Future.wait(
      creator.map((username) => profilePicGetter.getProfilePictures(username: username)),
    );

    return {
      'titles': titles,
      'body_text': bodyText,
      'tags': tags,
      'post_timestamp': postTimestamp,
      'creator': creator,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'is_liked': isLiked,
      'is_saved': isSaved,
      'pfp': profilePic,
    };

  }

  Future<List<T>> _generateVents<T>({
    required Map<String, dynamic> ventsData,
    required T Function(
      String title,
      String bodyText,
      String tags,
      String postTimestamp,
      String creator,
      Uint8List profilePic,
      int totalLikes,
      int totalComments,
      bool isPostLiked,
      bool isPostSaved,
    )
    ventBuilder,
  }) async {

    final titles = ventsData['titles'];
    final bodyText = ventsData['body_text'];
    final tags = ventsData['tags'];
    final postTimestamp = ventsData['post_timestamp'];
    final creator = ventsData['creator'];
    final profilePic = ventsData['pfp'];
    final totalLikes = ventsData['total_likes'];
    final totalComments = ventsData['total_comments'];
    final isLiked = ventsData['is_liked'];
    final isSaved = ventsData['is_saved'];

    return List.generate(titles.length, (index) {
      return ventBuilder(
        titles[index],
        bodyText[index],
        tags[index],
        postTimestamp[index],
        creator[index],
        profilePic[index],
        totalLikes[index],
        totalComments[index],
        isLiked[index],
        isSaved[index],
      );
    });

  }

  Future<void> _setupVents<T>({
    required Future<Map<String, dynamic>> Function() dataGetter,
    required void Function(List<T> vents) setVents,
    required T Function(
      String title,
      String bodyText,
      String tags,
      String postTimestamp,
      String creator,
      Uint8List profilePic,
      int totalLikes,
      int totalComments,
      bool isPostLiked,
      bool isPostSaved,
    )
    ventBuilder,
  }) async {

    final ventsInfo = await dataGetter();
    final ventsData = await _ventsData(ventsInfo: ventsInfo);
    final vents = await _generateVents(ventsData: ventsData, ventBuilder: ventBuilder);

    setVents(vents);

  }

  Future<void> setupForYou() async {
    await _setupVents<VentForYouData>(
      dataGetter: () => VentDataGetter().getVentsData(),
      setVents: forYouVentProvider.setVents,
      ventBuilder: (title, bodyText, tags, postTimestamp, creator, 
          profilePic, totalLikes, totalComments, isPostLiked, isPostSaved) => VentForYouData(
        title: title,
        bodyText: bodyText,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

  Future<void> setupTrending() async {
    await _setupVents<VentTrendingData>(
      dataGetter: () => VentDataGetter().getTrendingVentsData(),
      setVents: trendingVentProvider.setVents,
      ventBuilder: (title, bodyText, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isPostLiked, isPostSaved) => VentTrendingData(
        title: title,
        bodyText: bodyText,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

  Future<void> setupFollowing() async {
    await _setupVents<VentFollowingData>(
      dataGetter: () => VentDataGetter().getFollowingVentsData(),
      setVents: followingVentProvider.setVents,
      ventBuilder: (title, bodyText, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isPostLiked, isPostSaved) => VentFollowingData(
        title: title,
        bodyText: bodyText,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

  Future<void> setupSearch({required String searchText}) async {
    await _setupVents<SearchVents>(
      dataGetter: () => VentDataGetter().getSearchVentsData(
        searchTitleText: searchText,
      ),
      setVents: searchPostsProvider.setVents,
      ventBuilder: (title, _, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isPostLiked, isPostSaved) => SearchVents(
        title: title,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

  Future<void> setupLiked() async {
    await _setupVents<LikedVentData>(
      dataGetter: () => VentDataGetter().getLikedVentsData(),
      setVents: likedVentProvider.setVents,
      ventBuilder: (title, bodyText, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isPostLiked, isPostSaved) => LikedVentData(
        title: title,
        bodyText: bodyText,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

  Future<void> setupSaved() async {
    await _setupVents<SavedVentData>(
      dataGetter: () => VentDataGetter().getSavedVentsData(),
      setVents: savedVentProvider.setVents,
      ventBuilder: (title, bodyText, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isPostLiked, isPostSaved) => SavedVentData(
        title: title,
        bodyText: bodyText,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

}