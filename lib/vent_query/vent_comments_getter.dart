import 'package:revent/connection/revent_connect.dart';
import 'package:revent/model/extract_data.dart';

class VentCommentsGetter {

  final String title;
  final String creator;

  VentCommentsGetter({
    required this.title,
    required this.creator
  });

  Future<Map<String, List<String>>> getComments() async {

    final conn = await ReventConnect.initializeConnection();

    const getCommentsQuery = 
      'SELECT comment, commented_by FROM vent_comments_info WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': creator,
    };

    final results = await conn.execute(getCommentsQuery, params);

    final extractedData = ExtractData(rowsData: results);

    final commentedBy = extractedData.extractStringColumn('commented_by');
    final comment = extractedData.extractStringColumn('comment');

    return {
      'commented_by': commentedBy,
      'comment': comment
    };

  }

}