import 'package:get_it/get_it.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/shared/provider/user_data_provider.dart';

class UserPrivacyActions extends BaseQueryService {

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> privateAccount({required int isMakePrivate}) async {

    const query = 'UPDATE user_privacy_info SET privated_profile = :new_value WHERE username = :username';

    final param = {
      'username': userData.user.username,
      'new_value': isMakePrivate
    };

    await executeQuery(query, param);

  }
  
  Future<Map<String, int>> getCurrentOptions({required String username}) async {

    const query = 
      'SELECT privated_profile, privated_following_list, privated_saved_vents FROM user_privacy_info WHERE username = :username';

    final param = {
      'username': username,
    };

    final results = await executeQuery(query, param);

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