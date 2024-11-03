import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/profile/profile_info_widgets.dart';
import 'package:revent/widgets/profile/tabbar_widgets.dart';

class ProfileBodyWidgets extends StatelessWidget {

  final Future<void> Function() onRefresh;
  final bool isPronounsNotEmpty;

  final ProfileTabBarWidgets tabBarWidgets;
  final ProfileInfoWidgets profileInfoWidgets;
  
  final Widget pronounsWidget;
  final Widget bioWidget;
  final Widget userActionButtonWidget;
  final Widget popularityWidget;

  const ProfileBodyWidgets({
    required this.onRefresh,
    required this.isPronounsNotEmpty,
    required this.tabBarWidgets,
    required this.profileInfoWidgets,
    required this.pronounsWidget,
    required this.bioWidget,
    required this.userActionButtonWidget,
    required this.popularityWidget,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      notificationPredicate: (notification) {
        return notification.depth == 2;
      },
      color: ThemeColor.mediumBlack,
      onRefresh: onRefresh,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: isPronounsNotEmpty ? 308 : 286,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  children: [

                    profileInfoWidgets.buildProfilePicture(),

                    const SizedBox(height: 12),
                    profileInfoWidgets.buildUsername(),

                    pronounsWidget,
                    bioWidget,

                    const SizedBox(height: 25),
                    userActionButtonWidget,

                    const SizedBox(height: 28),
                    popularityWidget,

                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [

            const SizedBox(height: 16),
            
            tabBarWidgets.buildTabBar(),

            Expanded(
              child: tabBarWidgets.buildTabBarTabs(),
            ),

          ],
        ),
      ),
    );

  }

}