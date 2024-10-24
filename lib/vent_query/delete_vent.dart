import 'package:get_it/get_it.dart';
import 'package:revent/connection/revent_connect.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';

class DeleteVent {

  final ventData = GetIt.instance<VentDataProvider>();
  final userData = GetIt.instance<UserDataProvider>();

  Future<void> delete({required String ventTitle}) async {

    final conn = await ReventConnect.initializeConnection();

    const query = "DELETE FROM vent_info WHERE title = :title AND creator = :creator";
    final params = {
      'title': ventTitle,
      'creator': userData.user.username,
    };

    await conn.execute(query, params);

    _removeVent(title: ventTitle);

  }

  void _removeVent({required String title}) {

    final index = ventData.vents.indexWhere((vent) => vent.title == title);

    if(index != -1) {
      ventData.deleteVent(index);
    }

  }

}