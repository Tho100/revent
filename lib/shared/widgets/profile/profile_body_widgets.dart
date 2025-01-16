import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revent/shared/themes/theme_color.dart';
import 'package:revent/shared/widgets/profile/profile_info_widgets.dart';
import 'package:revent/shared/widgets/profile/tabbar_widgets.dart';
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
          header: 'This account is private', 
          subheader: 'Only approved followers can view the content.'
        )

      ],
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          profileInfoWidgets.buildProfilePicture(),
          
          const SizedBox(width: 12),

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
    );
  }

  Widget _buildPostsAndSavedTabs() {
    return Column(
      children: [

        tabBarWidgets.buildTabBar(),

        const Divider(color: ThemeColor.lightGrey, height: 1),

        Expanded(
          child: tabBarWidgets.buildTabBarTabs()
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
                
                _buildProfileInfo(),

                const SizedBox(height: 28),
                popularityWidget,

                const SizedBox(height: 28),
                userActionButtonWidget,

                const SizedBox(height: 20),

              ],
            ),
          ),
        ],
        body: isPrivateAccount! 
          ? _buildPrivateAccountMessage()
          : _buildPostsAndSavedTabs()
      ),
    );

  }

}