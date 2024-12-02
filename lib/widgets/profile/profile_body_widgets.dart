import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/profile/profile_info_widgets.dart';
import 'package:revent/widgets/profile/tabbar_widgets.dart';

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
              expandedHeight: 252,
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if(isPrivateAccount!)
                    Padding(
                      padding: const EdgeInsets.only(left: 26.0, top: 5.0),
                      child: Row(
                        children: [
                    
                          const Icon(CupertinoIcons.lock, color: ThemeColor.secondaryWhite, size: 16),
                    
                          const SizedBox(width: 4),
                    
                          Text(
                            'This is a private account.',
                            style: GoogleFonts.inter(
                              color: ThemeColor.secondaryWhite,
                              fontWeight: FontWeight.w800,
                              fontSize: 13
                            )
                          )
                    
                        ]
                      ),
                    ),

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

                  ],
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                tabBarWidgets.buildTabBar(),

                const Divider(color: ThemeColor.lightGrey, height: 1)

              ],
            ),

            Expanded(
              child: tabBarWidgets.buildTabBarTabs(),
            ),

          ],
        ),
      ),
    );

  }

}