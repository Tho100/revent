import 'package:get_it/get_it.dart';
import 'package:revent/data_query/crud.dart';
import 'package:revent/provider/vent_data_provider.dart';

class CreateNewItem {

  final crud = Crud();

  final ventData = GetIt.instance<VentDataProvider>();

  Future<void> newVent({
    required String ventTitle,
    required String ventBodyText,
  }) async {

    const creator = "dan";

    const query = "INSERT INTO vent_info (creator, title, body_text, total_likes, total_comments) VALUES (:creator, :title, :body_text, :total_likes, :total_comments)";
    final params = {
      'creator': creator,
      'title': ventTitle,
      'body_text': ventBodyText,
      'total_likes': 0,
      'total_comments': 0,
    };

    try {

      await crud.execute(query: query, params: params);

      ventData.ventTitles.add(ventTitle);

    } catch (err) {
      print(err.toString());
    }

  }

  void newForum() {

  }

}