import 'package:revent/connection/revent_connect.dart';

class VentGetter {

  Future<List<Map<String, String?>>> getVentsData() async {

    final conn = await ReventConnect.initializeConnection();

    const query = "SELECT title, creator FROM vent_info";
    
    final retrievedVents = await conn.execute(query);

    return retrievedVents.rows
      .map((row) => {
        'title': row.assoc()['title'], 
        'creator': row.assoc()['creator'],  
    }).toList();

  }

}