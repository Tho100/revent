import 'package:get_it/get_it.dart';
import 'package:revent/vent_query/vent_data_getter.dart';
import 'package:revent/provider/vent_data_provider.dart';

class VentDataSetup {

  final ventData = GetIt.instance<VentDataProvider>();
  
  final ventDataGetter = VentDataGetter();

  void _initializeData({
    required List<String> title,
    required List<String> bodyText,
    required List<String> creator,
    required List<String> postTimestamp,
    required List<int> totalLikes,
    required List<int> totalComments,
  }) {

    ventData.setVentTitles(title);
    ventData.setVentBodyText(bodyText);
    ventData.setVentCreator(creator);
    ventData.setVentPostTimestamp(postTimestamp);
    
    ventData.setVentTotalLikes(totalLikes);
    ventData.setVentTotalComments(totalComments);

  }

  Future<void> setup() async {

    final ventData = await ventDataGetter.getVentsData();

    final title = ventData['title']! as List<String>;
    final bodyText = ventData['body_text']! as List<String>;
    final creator = ventData['creator']! as List<String>;
    final postTimestamp = ventData['post_timestamp']! as List<String>;

    final totalLikes = ventData['total_likes']! as List<int>;
    final totalComments = ventData['total_comments']! as List<int>;

    _initializeData(
      title: title, bodyText: bodyText, creator: creator, postTimestamp: postTimestamp,
      totalLikes: totalLikes, totalComments: totalComments,
    );

  }

}