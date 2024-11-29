import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_profile/profile_picture_getter.dart';
import 'package:revent/provider/vent/vent_following_data_provider.dart';
import 'package:revent/vent_query/vent_data_getter.dart';
import 'package:revent/provider/vent/vent_data_provider.dart';

class VentDataSetup {

  final ventData = GetIt.instance<VentDataProvider>();
  final ventFollowingData = GetIt.instance<VentFollowingDataProvider>();

  Future<void> setup() async {

    final ventsInfo = await VentDataGetter().getVentsData();

    final titles = ventsInfo['title']! as List<String>;
    final bodyText = ventsInfo['body_text']! as List<String>;
    final creator = ventsInfo['creator']! as List<String>;
    final postTimestamp = ventsInfo['post_timestamp']! as List<String>;

    final totalLikes = ventsInfo['total_likes']! as List<int>;
    final totalComments = ventsInfo['total_comments']! as List<int>;

    final isLiked = ventsInfo['is_liked']! as List<bool>;
    final isSaved = ventsInfo['is_saved']! as List<bool>;

    final profilePicGetter = ProfilePictureGetter();

    final profilePic = await Future.wait(
      creator.map((username) async => await profilePicGetter.getProfilePictures(username: username)
      )
    );

    final vents = List.generate(titles.length, (index) {
      return Vent(
        title: titles[index],
        bodyText: bodyText[index],
        creator: creator[index],
        postTimestamp: postTimestamp[index],
        profilePic: profilePic[index],
        totalLikes: totalLikes[index],
        totalComments: totalComments[index],
        isPostLiked: isLiked[index],
        isPostSaved: isSaved[index],
      );
    });

    ventData.setVents(vents);

  }

  Future<void> setupFollowing() async {

    final ventsInfo = await VentDataGetter().getFollowingVentsData();

    final titles = ventsInfo['title']! as List<String>;
    final bodyText = ventsInfo['body_text']! as List<String>;
    final creator = ventsInfo['creator']! as List<String>;
    final postTimestamp = ventsInfo['post_timestamp']! as List<String>;

    final totalLikes = ventsInfo['total_likes']! as List<int>;
    final totalComments = ventsInfo['total_comments']! as List<int>;

    final isLiked = ventsInfo['is_liked']! as List<bool>;
    final isSaved = ventsInfo['is_saved']! as List<bool>;

    final profilePicGetter = ProfilePictureGetter();

    final profilePic = await Future.wait(
      creator.map((username) async => await profilePicGetter.getProfilePictures(username: username)
      )
    );

    final vents = List.generate(titles.length, (index) {
      return VentFollowing(
        title: titles[index],
        bodyText: bodyText[index],
        creator: creator[index],
        postTimestamp: postTimestamp[index],
        profilePic: profilePic[index],
        totalLikes: totalLikes[index],
        totalComments: totalComments[index],
        isPostLiked: isLiked[index],
        isPostSaved: isSaved[index],
      );
    });

    ventFollowingData.setVents(vents);

  }

}