import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/provider/navigation_provider.dart';
import 'package:revent/model/update_navigation.dart';
import 'package:revent/themes/theme_color.dart';

class ProfilePage extends StatelessWidget {

  ProfilePage({super.key});

  final navigationIndex = GetIt.instance<NavigationProvider>();

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width - 15,
          height: 125,
          decoration: BoxDecoration(
            color: ThemeColor.white,
            borderRadius: BorderRadius.circular(18)
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    navigationIndex.setPageIndex(4);
    return WillPopScope(
      onWillPop: () async {
        NavigatePage.homePage(context);
        return true;
      },
      child: Scaffold(
        body: _buildBody(context),
        bottomNavigationBar: UpdateNavigation(
          context: context,
        ).showNavigationBar(),
      ),
    );
  }

}