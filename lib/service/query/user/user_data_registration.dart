import 'package:revent/shared/api/api_client.dart';
import 'package:revent/shared/api/api_path.dart';
import 'package:revent/shared/provider_mixins.dart';

class UserDataRegistration with UserProfileProviderService { 

  Future<int> registerUser({required String? password}) async {

    final response = await ApiClient.post(ApiPath.register, {
      'username': userProvider.user.username,
      'email': userProvider.user.email,
      'password': password
    });

    return response.statusCode;

  }  

}