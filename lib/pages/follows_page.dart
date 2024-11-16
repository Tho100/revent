import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_query/follows_getter.dart';
import 'package:revent/helper/navigate_page.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/sub_button.dart';
import 'package:revent/widgets/inkwell_effect.dart';
import 'package:revent/widgets/profile_picture.dart';

class _FollowsUserData {

  final String username;
  final Uint8List profilePic;

  _FollowsUserData({
    required this.username, 
    required this.profilePic
  });

}

class FollowsPage extends StatefulWidget {

  final String pageType;
  final String username;

  const FollowsPage({
    required this.pageType,
    required this.username, 
    super.key
  });

  @override
  State<FollowsPage> createState() => FollowsPageState();

}

class FollowsPageState extends State<FollowsPage> {

  final followsUserDataNotifier = ValueNotifier<List<_FollowsUserData>>([]);

  final userData = GetIt.instance<UserDataProvider>();

  final emptyMessages = {
    'Followers': 'No followers yet.',
    'Following': 'No following yet.',
  };

  Future<void> _loadData() async {

    try {

      final getFollowsInfo = await FollowsGetter().getFollows(
        followType: widget.pageType, username: widget.username
      );

      final usernames = getFollowsInfo['username']!;
      final profilePics = getFollowsInfo['profile_pic']!;

      final followsUserInfoList = List.generate(usernames.length, (index) {
        return _FollowsUserData(
          username: usernames[index],
          profilePic: profilePics[index],
        );
      });

      followsUserDataNotifier.value = followsUserInfoList;

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to load profiles');
    }
    
  }

  String _profileButtonText() {

    if (widget.pageType == 'Followers') {
      return 'Follow';

    } else if (widget.pageType == 'Following') {
      final isMyProfile = userData.user.username == widget.username;
      return isMyProfile ? 'Unfollow' : 'Follow';
    } 

    return '';

  }

  Widget _buildListViewItems(String username, Uint8List pfpData) {
    return InkWellEffect(
      onPressed: () => NavigatePage.userProfilePage(username: username, pfpData: pfpData),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
      
            ProfilePictureWidget(
              customWidth: 45,
              customHeight: 45,
              pfpData: pfpData
            ),
      
            const SizedBox(width: 10),
      
            Text(
              username,
              style: GoogleFonts.inter(
                color: ThemeColor.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
      
            const Spacer(),

            Visibility(
              visible: username != userData.user.username,
              child: SubButton(
                customHeight: 40,
                text: _profileButtonText(),
                onPressed: () => print(widget.pageType)
              ),
            ),
      
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics()
      ),
      itemCount: followsUserDataNotifier.value.length,
      itemBuilder: (_, index) {
        final followsUserData = followsUserDataNotifier.value[index];
        return _buildListViewItems(followsUserData.username, followsUserData.profilePic);
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 28,
          child: ValueListenableBuilder(
            valueListenable: followsUserDataNotifier, 
            builder: (_, followsUserDataList, __) {
              return followsUserDataList.isEmpty 
                ?  EmptyPage().customMessage(message: emptyMessages[widget.pageType]!)
                : _buildListView();
            }
          )
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: widget.pageType
      ).buildAppBar(),
      body: _buildBody(),
    );
  }

}