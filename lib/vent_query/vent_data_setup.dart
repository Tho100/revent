import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_profile/profile_picture_getter.dart';
import 'package:revent/vent_query/vent_data_getter.dart';
import 'package:revent/provider/vent_data_provider.dart';

class VentDataSetup {

  final ventDataProvider = GetIt.instance<VentDataProvider>();
  
  final ventDataGetter = VentDataGetter();
  final profilePicGetter = ProfilePictureGetter();

  Future<void> setup() async {

    final ventData = await ventDataGetter.getVentsData();

    final titles = ventData['title']! as List<String>;
    final bodyText = ventData['body_text']! as List<String>;
    final creator = ventData['creator']! as List<String>;
    final postTimestamp = ventData['post_timestamp']! as List<String>;

    final totalLikes = ventData['total_likes']! as List<int>;
    final totalComments = ventData['total_comments']! as List<int>;

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
      );
    });

    ventDataProvider.setVents(vents);

  }

}