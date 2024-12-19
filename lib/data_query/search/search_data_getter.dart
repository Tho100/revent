import 'package:revent/service/revent_connection_service.dart';

class SearchDataGetter {

  final String title;
  final String creator;

  SearchDataGetter({
    required this.title, 
    required this.creator
  });

  Future<String> getBodyText() async {

    final conn = await ReventConnection.connect();

    const query = 'SELECT body_text FROM vent_info WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': creator
    };

    final results = await conn.execute(query, params);

    return results.rows.last.assoc()['body_text']!;
    
  }

}