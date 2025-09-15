import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';

class UserDataRegistration extends BaseQueryService with UserProfileProviderService { 

  Future<int> registerUser({required String? password}) async {

    final response = await ApiClient.post(ApiPath.register, {
      'username': userProvider.user.username,
      'email': userProvider.user.email,
      'password': password
    });

    return response.statusCode;

  }  

}