import 'package:get_it/get_it.dart';
import 'package:revent/data_query/user_profile/profile_data_setup.dart';
import 'package:revent/provider/profile_data_provider.dart';
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

  Future<void> refreshProfile() async {

    final profileData = GetIt.instance<ProfileDataProvider>();

    profileData.clearProfileData();

    await ProfileDataSetup().setup(username: userData.user.username);

  }

}