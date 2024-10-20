import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/vent_data_provider.dart';

class VentActions {

  final String title;
  final String creator;

  VentActions({
    required this.title,
    required this.creator
  });

  final ventData = GetIt.instance<VentDataProvider>();

  Future<void> likePost() async {

    final conn = await ReventConnect.initializeConnection();

    final index = ventData.vents.indexWhere(
      (vent) => vent.title == title && vent.creator == creator
    );

    final operationSymbol = ventData.vents[index].isPostLiked ? '+' : '-';

    final updateLikeValueQuery = 
      'UPDATE vent_info SET total_likes = total_likes $operationSymbol 1 WHERE creator = :creator AND title = :title';

    final param = {
      'creator': creator,
      'title': title
    };

    await conn.execute(updateLikeValueQuery, param);

    _updatePostLikeValue(index: index);

  }

  void _updatePostLikeValue({required int index}) {

    if(index != -1) {
      ventData.likeVent(index);
    }

  }

  Future<void> savePost() async {}

  Future<void> sendComment() async {}

}