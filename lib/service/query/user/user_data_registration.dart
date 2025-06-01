import 'package:revent/helper/providers_service.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/model/local_storage_model.dart';

class UserDataRegistration extends BaseQueryService with UserProfileProviderService { 

  final localStorageModel = LocalStorageModel();

  Future<void> registerUser({required String? hashPassword}) async {
      
    const queries = [
      'INSERT INTO user_information (username, email, password) VALUES (:username, :email, :password)',
      'INSERT INTO user_profile_info (bio, followers, following, posts, profile_picture, username) VALUES (:bio, :followers, :following, :posts, :profile_pic, :username)',
      'INSERT INTO user_privacy_info (username) VALUES (:username)'
    ];

    final params = [
      {
        'username': userProvider.user.username,
        'email': userProvider.user.email,
        'password': hashPassword,
      },
      {
        'bio': '',
        'followers': 0,
        'following': 0,
        'posts': 0,
        'profile_pic': '',
        'username': userProvider.user.username
      },
      {
        'username': userProvider.user.username
      }
    ];

    final conn = await connection();

    await conn.transactional((txn) async {
      for(int i=0; i <queries.length; i++) {
        await txn.execute(queries[i], params[i]);
      }
    });

    await localStorageModel.setupAccountInformation(
      username: userProvider.user.username, email: userProvider.user.email
    );

    await localStorageModel.setupThemeInformation(theme: 'dark');

  }  

}