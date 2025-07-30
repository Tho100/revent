import 'package:revent/global/table_names.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/service/query/general/base_query_service.dart';
import 'package:revent/model/local_storage_model.dart';

class UserDataRegistration extends BaseQueryService with UserProfileProviderService { 

  Future<void> registerUser({required String? passwordHash}) async {

    final conn = await connection();

    await conn.transactional((txn) async {
      
      await txn.execute(
        'INSERT INTO ${TableNames.userInfo} (username, email, password) VALUES (:username, :email, :password)',
        {
          'username': userProvider.user.username,
          'email': userProvider.user.email,
          'password': passwordHash,
        }
      );

      await txn.execute(
        '''
          INSERT INTO ${TableNames.userProfileInfo} 
            (bio, followers, following, posts, profile_picture, username) 
          VALUES 
            (:bio, :followers, :following, :posts, :profile_pic, :username)
        ''',
        {
          'bio': '',
          'followers': 0,
          'following': 0,
          'posts': 0,
          'profile_pic': '',
          'username': userProvider.user.username
        }
      );

      await txn.execute(
        'INSERT INTO ${TableNames.userPrivacyInfo} (username) VALUES (:username)',
        {'username': userProvider.user.username}
      );

    });

    final localStorageModel = LocalStorageModel();

    await localStorageModel.setupAccountInformation(
      username: userProvider.user.username, email: userProvider.user.email
    );

    await localStorageModel.setupThemeInformation(theme: 'dark');

  }  

}