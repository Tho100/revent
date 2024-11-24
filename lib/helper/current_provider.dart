import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/provider/vent_data_provider.dart';
import 'package:revent/provider/vent_following_data_provider.dart';

class CurrentProvider {

  BuildContext context;
  String title;
  String creator;

  CurrentProvider({
    required this.context,
    required this.title,
    required this.creator,
  });

  Map<String, dynamic> getProvider() {

    final navigation = GetIt.instance<NavigationProvider>();

    dynamic ventData;

    if(navigation.pageIndex == 0) {
      ventData = navigation.activeTabIndex == 0 
        ? Provider.of<VentDataProvider>(context) : Provider.of<VentFollowingDataProvider>(context);
    } 

    final index = ventData.vents.indexWhere(
      (vent) => vent.title == title && vent.creator == creator
    );

    return {
      'vent_index': index,
      'vent_data': ventData
    };

  }

}