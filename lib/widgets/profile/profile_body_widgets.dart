import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/profile/profile_info_widgets.dart';
import 'package:revent/widgets/profile/tabbar_widgets.dart';
import 'package:revent/pages/empty_page.dart';

class ProfileBodyWidgets extends StatelessWidget {

  final Future<void> Function() onRefresh;
    
  final ProfileTabBarWidgets tabBarWidgets;
  final ProfileInfoWidgets profileInfoWidgets;
  
  final Widget pronounsWidget;
  final Widget bioWidget;
  final Widget userActionButtonWidget;
  final Widget popularityWidget;

  final bool? isPrivateAccount;

  const ProfileBodyWidgets({
    required this.onRefresh,
    required this.tabBarWidgets,
    required this.profileInfoWidgets,
    required this.pronounsWidget,
    required this.bioWidget,
    required this.userActionButtonWidget,
    required this.popularityWidget,
    this.isPrivateAccount = false,
    super.key
  });

  Widget _buildPrivateAccountMessage() {
    return Column(
      children: [

        const SizedBox(height: 35),

        const Icon(CupertinoIcons.lock, color: ThemeColor.secondaryWhite, size: 32),

        const SizedBox(height: 18),

        EmptyPage().headerCustomMessage(
          header: 'This is a private account', 
          subheader: 'Only followers can see the \nposts, followers and following list on this profile.'
        )

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      notificationPredicate: (notification) {
        return notification.depth == 2;
      },
      color: ThemeColor.mediumBlack,
      onRefresh: onRefresh,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: Create a separated function for this code
                Padding(
                  padding: EdgeInsets.only(left: 24.0, top: isPrivateAccount! ? 25.0 : 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      profileInfoWidgets.buildProfilePicture(),
                      
                      const SizedBox(width: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 4),

                          profileInfoWidgets.buildUsername(),
                          pronounsWidget,
                          bioWidget,

                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                popularityWidget,

                const SizedBox(height: 28),
                userActionButtonWidget,

                const SizedBox(height: 20),

              ],
            ),
          ),
        ],
        body: Column(
          children: [

            if (isPrivateAccount!)
              _buildPrivateAccountMessage()
            else ... [
              // TODO: Create a separated function for this code
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  tabBarWidgets.buildTabBar(),

                  const Divider(color: ThemeColor.lightGrey, height: 1),

                ],
              ),

              Expanded(
                child: tabBarWidgets.buildTabBarTabs()
              ),

            ]

          ],
        ),
      ),
    );

  }

}