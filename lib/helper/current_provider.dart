import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/profile_posts_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/provider/vent_following_data_provider.dart';

class CurrentProvider {

  String title;
  String creator;

  CurrentProvider({
    required this.title,
    required this.creator,
  });

  final navigation = GetIt.instance<NavigationProvider>();

  Map<String, dynamic> getProvider() {

    dynamic ventData;

    int index = 0;

    if(navigation.currentPageIndex == 0) {

      ventData = navigation.homeTabIndex == 0 
        ? GetIt.instance<VentDataProvider>()
        : GetIt.instance<VentFollowingDataProvider>();

      index = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      );

    } else if (navigation.currentPageIndex == 4) {

      ventData = GetIt.instance<ProfilePostsProvider>();

      final profileData = ventData.myProfile;

      index = profileData.titles.indexWhere(
        (ventTitle) => ventTitle == title
      );

    }

    return {
      'vent_index': index,
      'vent_data': ventData
    };

  }

  Map<String, dynamic> getRealTimeProvider({required BuildContext context}) {

    dynamic ventData;

    int index = 0;

    if(navigation.currentPageIndex == 0) {

      ventData = navigation.homeTabIndex == 0 
        ? Provider.of<VentDataProvider>(context)  
        : Provider.of<VentFollowingDataProvider>(context);

      index = ventData.vents.indexWhere(
        (vent) => vent.title == title && vent.creator == creator
      );

    } else if (navigation.currentPageIndex == 4) {

      ventData = Provider.of<ProfilePostsProvider>(context); 

      index = ventData.titles.indexWhere(
        (vent) => vent.title == title
      );

    }

    return {
      'vent_index': index,
      'vent_data': ventData
    };

  }

}