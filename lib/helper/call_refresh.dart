import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_profile/profile_data_setup.dart';
import 'package:revent/data_query/user_profile/profile_posts_getter.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/provider/profile_posts_provider.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/vent_query/vent_data_setup.dart';

class CallRefresh {

  final userData = GetIt.instance<UserDataProvider>();

  Future<void> refreshVents() async {

    final ventData = GetIt.instance<VentDataProvider>();

    ventData.deleteVentsData();

    await VentDataSetup().setup();

  }

  Future<void> refreshProfile({required String username}) async {

    final profileData = GetIt.instance<ProfileDataProvider>();
    final profilePostsData = GetIt.instance<ProfilePostsProvider>();

    profileData.clearProfileData();

    await ProfileDataSetup().setup(username: username);

    final getPostsData = await ProfilePostsGetter()
      .getPosts(username: username);

    profilePostsData.setMyProfileTitles(getPostsData);

  }

}