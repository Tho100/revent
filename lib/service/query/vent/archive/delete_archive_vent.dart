import 'package:get_it/get_it.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/shared/provider/user_data_provider.dart';

class DeleteArchiveVent {
  
  final String title;

  DeleteArchiveVent({
    required this.title,
  });

  final userData = GetIt.instance<UserDataProvider>();

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