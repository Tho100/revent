import 'package:get_it/get_it.dart';
import 'package:revent/service/revent_connection_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/provider/user_data_provider.dart';

class UserPrivacyActions {

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> privateAccount({required int isMakePrivate}) async {

    final conn = await ReventConnection.connect();

    const query = 'UPDATE user_privacy_info SET privated_profile = :new_value WHERE username = :username';

    final param = {
      'username': userData.user.username,
      'new_value': isMakePrivate
    };

    await conn.execute(query, param);

  }
  
  Future<Map<String, int>> getCurrentOptions({required String username}) async {

    final conn = await ReventConnection.connect();

    const query = 
      'SELECT privated_profile, privated_following_list, privated_saved_vents FROM user_privacy_info WHERE username = :username';

    final param = {
      'username': username,
    };

    final results = await conn.execute(query, param);

    final extractedData = ExtractData(rowsData: results);

    final privatedAccount = extractedData.extractIntColumn('privated_profile')[0];
    final privatedFollowing = extractedData.extractIntColumn('privated_following_list')[0];
    final privatedSaved = extractedData.extractIntColumn('privated_saved_vents')[0];

    return {
      'account': privatedAccount,
      'following': privatedFollowing,
      'saved': privatedSaved,
    };

  }

}