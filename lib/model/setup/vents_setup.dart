import 'dart:typed_data';

import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/shared/provider/search/search_posts_provider.dart';
import 'package:revent/shared/provider/vent/liked_vent_provider.dart';
import 'package:revent/shared/provider/vent/saved_vent_provider.dart';
import 'package:revent/shared/provider/vent/vent_following_provider.dart';
import 'package:revent/service/query/vent/vents_getter.dart';
import 'package:revent/shared/provider/vent/vent_latest_provider.dart';
import 'package:revent/shared/provider/vent/vent_trending_provider.dart';

class VentsSetup with VentProviderService, SearchProviderService, LikedSavedProviderService {

  /// Processes raw vent info map by extracting fields and 
  /// asynchronously fetching profile picture for each creator
  //
  /// Return a map containing list of all vent properties 
  /// including decoded profile picture.

  Future<dynamic> _rawVentsData({required Map<String, dynamic> ventsInfo}) async {

    final postIds = ventsInfo['post_id'] as List<int>;
    final titles = ventsInfo['title']! as List<String>;
    final bodyText = ventsInfo['body_text']! as List<String>;
    final tags = ventsInfo['tags']! as List<String>;
    final postTimestamp = ventsInfo['post_timestamp']! as List<String>;
    final creator = ventsInfo['creator']! as List<String>;
    final profilePictures = ventsInfo['profile_picture']! as List<Uint8List>;
    final totalLikes = ventsInfo['total_likes']! as List<int>;
    final totalComments = ventsInfo['total_comments']! as List<int>;
    final isNsfw = ventsInfo['is_nsfw']! as List<bool>;
    final isLiked = ventsInfo['is_liked']! as List<bool>;
    final isSaved = ventsInfo['is_saved']! as List<bool>;

    return {
      'post_id': postIds,
      'titles': titles,
      'body_text': bodyText,
      'tags': tags,
      'post_timestamp': postTimestamp,
      'creator': creator,
      'profile_picture': profilePictures,
      'total_likes': totalLikes,
      'total_comments': totalComments,
      'is_nsfw': isNsfw,
      'is_liked': isLiked,
      'is_saved': isSaved,
    };

  }

  /// Generate a list of vent object of type T using the provided [ventBuilder]
  /// function, which maps raw vent data fields to T
  ///
  /// Assumes all lists in [ventsData] have equal length.

  Future<List<T>> _generateVents<T>({
    required Map<String, dynamic> ventsData,
    required T Function(
      int postId,
      String title,
      String bodyText,
      String tags,
      String postTimestamp,
      String creator,
      Uint8List profilePic,
      int totalLikes,
      int totalComments,
      bool isNsfw,
      bool isPostLiked,
      bool isPostSaved,
    )
    ventBuilder,
  }) async {

    final postIds = ventsData['post_id'];
    final titles = ventsData['titles'];
    final bodyText = ventsData['body_text'];
    final tags = ventsData['tags'];
    final postTimestamp = ventsData['post_timestamp'];
    final creator = ventsData['creator'];
    final profilePicture = ventsData['profile_picture'];
    final totalLikes = ventsData['total_likes'];
    final totalComments = ventsData['total_comments'];
    final isNsfw = ventsData['is_nsfw'];
    final isLiked = ventsData['is_liked'];
    final isSaved = ventsData['is_saved'];

    final count = postIds.length;

    return List.generate(count, (index) {
      return ventBuilder(
        postIds[index],
        titles[index],
        bodyText[index],
        tags[index],
        postTimestamp[index],
        creator[index],
        profilePicture[index],
        totalLikes[index],
        totalComments[index],
        isNsfw[index],
        isLiked[index],
        isSaved[index],
      );
    });

  }

  /// Manages the fetching and building of vents.
  /// - Calls [dataGetter] to fetch raw vent info.
  /// - Processes it into structured data with [_rawVentsData].
  /// - Generates typed vent objects with [_generateVents].
  /// - Finally sets the vents by calling [setVents].

  Future<void> _setupVents<T>({
    required Future<Map<String, dynamic>> Function() dataGetter,
    required void Function(List<T> vents) setVents,
    required T Function(
      int postId,
      String title,
      String bodyText,
      String tags,
      String postTimestamp,
      String creator,
      Uint8List profilePic,
      int totalLikes,
      int totalComments,
      bool isNsfw,
      bool isPostLiked,
      bool isPostSaved,
    )
    ventBuilder,
  }) async {

    final ventsInfo = await dataGetter();
    final ventsData = await _rawVentsData(ventsInfo: ventsInfo);
    final vents = await _generateVents(ventsData: ventsData, ventBuilder: ventBuilder);

    setVents(vents);

  }

  final _ventsGetter = VentsGetter();

  Future<void> setupLatest() async {
    await _setupVents<VentLatestData>(
      dataGetter: _ventsGetter.getLatestVentsData,
      setVents: latestVentProvider.setVents,
      ventBuilder: (postId, title, bodyText, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isNsfw, isPostLiked, isPostSaved) => VentLatestData(
        postId: postId,
        title: title,
        bodyText: bodyText,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isNsfw: isNsfw,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

  Future<void> setupTrending() async {
    await _setupVents<VentTrendingData>(
      dataGetter: _ventsGetter.getTrendingVentsData,
      setVents: trendingVentProvider.setVents,
      ventBuilder: (postId, title, bodyText, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isNsfw, isPostLiked, isPostSaved) => VentTrendingData(
        postId: postId,
        title: title,
        bodyText: bodyText,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isNsfw: isNsfw,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

  Future<void> setupFollowing() async {
    await _setupVents<VentFollowingData>(
      dataGetter: _ventsGetter.getFollowingVentsData,
      setVents: followingVentProvider.setVents,
      ventBuilder: (postId, title, bodyText, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isNsfw, isPostLiked, isPostSaved) => VentFollowingData(
        postId: postId,
        title: title,
        bodyText: bodyText,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isNsfw: isNsfw,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

  Future<void> setupSearch({required String searchText}) async {
    await _setupVents<SearchVentsData>(
      dataGetter: () => _ventsGetter.getSearchVentsData(
        searchText: searchText,
      ),
      setVents: searchPostsProvider.setVents,
      ventBuilder: (postId, title, _, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isNsfw, isPostLiked, isPostSaved) => SearchVentsData(
        postId: postId,
        title: title,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isNsfw: isNsfw,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

  Future<void> setupLiked() async {
    await _setupVents<LikedVentData>(
      dataGetter: _ventsGetter.getLikedVentsData,
      setVents: likedVentProvider.setVents,
      ventBuilder: (postId, title, bodyText, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isNsfw, isPostLiked, isPostSaved) => LikedVentData(
        postId: postId,
        title: title,
        bodyText: bodyText,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isNsfw: isNsfw,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

  Future<void> setupSaved() async {
    await _setupVents<SavedVentData>(
      dataGetter: _ventsGetter.getSavedVentsData,
      setVents: savedVentProvider.setVents,
      ventBuilder: (postId, title, bodyText, tags, postTimestamp, creator,
          profilePic, totalLikes, totalComments, isNsfw, isPostLiked, isPostSaved) => SavedVentData(
        postId: postId,
        title: title,
        bodyText: bodyText,
        tags: tags,
        postTimestamp: postTimestamp,
        creator: creator,
        profilePic: profilePic,
        totalLikes: totalLikes,
        totalComments: totalComments,
        isNsfw: isNsfw,
        isPostLiked: isPostLiked,
        isPostSaved: isPostSaved,
      ),
    );
  }

}