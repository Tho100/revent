import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/model/local_storage_model.dart';

class UserDataRegistration extends BaseQueryService { 

  final userData = getIt.userProvider;

  Future<void> insert({required String? hashPassword}) async {
      
    const queries = 
    [
      'INSERT INTO user_information (username, email, password, plan) VALUES (:username, :email, :password, :plan)',
      'INSERT INTO user_profile_info (bio, followers, following, posts, profile_picture, username) VALUES (:bio, :followers, :following, :posts, :profile_pic, :username)',
      'INSERT INTO user_privacy_info (username) VALUES (:username)'
    ];

    final params = [
      {
        'username': userData.user.username,
        'email': userData.user.email,
        'password': hashPassword,
        'plan': 'Basic'
      },
      {
        'bio': '',
        'followers': 0,
        'following': 0,
        'posts': 0,
        'profile_pic': '',
        'username': userData.user.username
      },
      {
        'username': userData.user.username
      }
    ];

    final conn = await connection();

    await conn.transactional((txn) async {
      for(int i=0; i <queries.length; i++) {
        await txn.execute(queries[i], params[i]);
      }
    });

    await LocalStorageModel().setupLocalAccountInformation(
      username: userData.user.username, email: userData.user.email, plan: 'Basic'
    );

  }  

}