import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:revent/data_query/follows_getter.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/provider/profile_data_provider.dart';
import 'package:revent/themes/theme_color.dart';
import 'package:revent/widgets/app_bar.dart';
import 'package:revent/widgets/buttons/main_button.dart';
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

  const FollowsPage({
    required this.pageType, 
    super.key
  });

  @override
  State<FollowsPage> createState() => FollowsPageState();

}

class FollowsPageState extends State<FollowsPage> {

  final followsUserDataNotifier = ValueNotifier<List<_FollowsUserData>>([]);

  final profileData = GetIt.instance<ProfileDataProvider>();

  Future<void> _loadData() async {

    try {

      final getFollowsInfo = await FollowsGetter().getFollows(followType: widget.pageType);

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
      print(err.toString());
    }
    
  }


  Widget _buildListViewItems(String username, Uint8List pfpData) {
    return Padding(
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
              fontSize: 16,
            ),
          ),
    
          const Spacer(),
    
          MainButton(
            customWidth: MediaQuery.of(context).size.width * 0.19,
            customHeight: 40,
            customFontSize: 13,
            text: widget.pageType == 'Followers' ? 'Remove' : 'Follow',
            onPressed: () => print(widget.pageType)
          ),
    
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: followsUserDataNotifier.value.length,
      itemBuilder: (_, index) {
        final followsUserData = followsUserDataNotifier.value[index];
        return _buildListViewItems(followsUserData.username, followsUserData.profilePic);
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 28,
          child: ValueListenableBuilder(
            valueListenable: followsUserDataNotifier, 
            builder: (_, followsUserDataList, __) {
              return followsUserDataList.isEmpty 
                ?  EmptyPage().nothingToSeeHere()
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
      body: _buildBody(context),
    );
  }

}