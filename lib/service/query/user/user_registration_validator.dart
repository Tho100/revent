import 'package:revent/global/table_names.dart';
import 'package:revent/helper/extract_data.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserRegistrationValidator extends BaseQueryService {

  final String username;
  final String email;

  UserRegistrationValidator({
    required this.username, 
    required this.email
  });

  Future<Map<String, bool>> verifyUsernameAndEmail() async {

    const query = 
    '''
    SELECT
	    EXISTS (SELECT 1 FROM ${TableNames.userInfo} WHERE username = :username) AS username_exists,
      EXISTS (SELECT 1 FROM ${TableNames.userInfo} WHERE email = :email) AS email_exists;
    ''';

    final params = {
      'username': username,
      'email': email
    };

    final results = await executeQuery(query, params);

    final extractedData = ExtractData(rowsData: results);

    final usernameExists = extractedData.extractIntColumn('username_exists')[0] == 1;
    final emailExists = extractedData.extractIntColumn('email_exists')[0] == 1;

    return {
      'username_exists': usernameExists,
      'email_exists': emailExists
    };

  }

}