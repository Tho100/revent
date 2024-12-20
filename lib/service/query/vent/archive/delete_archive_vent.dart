import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/revent_connection_service.dart';

class DeleteArchiveVent {
  // TODO: Usebasequeryservice
  final String title;

  DeleteArchiveVent({
    required this.title,
  });

  final userData = getIt.userProvider;

  Future<void> delete() async {

    final conn = await ReventConnection.connect();

    const query = 'DELETE FROM archive_vent_info WHERE title = :title AND creator = :creator';

    final params = {
      'title': title,
      'creator': userData.user.username,
    };

    await conn.execute(query, params);

  }

}