// ignore_for_file: library_private_types_in_public_api

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/service/query/follows_getter.dart';
import 'package:revent/pages/empty_page.dart';
import 'package:revent/shared/provider/user_data_provider.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/shared/widgets/account_profile.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/custom_tab_bar.dart';

class _FollowsProfilesData {
  
  final String username;
  final Uint8List profilePic;

  _FollowsProfilesData({
    required this.username,
    required this.profilePic,
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
  State<FollowsPage> createState() => _FollowsPageState();

}

class _FollowsPageState extends State<FollowsPage> with SingleTickerProviderStateMixin {

  final userData = GetIt.instance<UserDataProvider>();

  final ValueNotifier<List<_FollowsProfilesData>> followersData = ValueNotifier([]);
  final ValueNotifier<List<_FollowsProfilesData>> followingData = ValueNotifier([]);

  final emptyPageMessageNotifier = ValueNotifier<String>('');
  final profileActionTextNotifier = ValueNotifier<String>('');

  final emptyMessages = {
    'Followers': 'No followers yet.',
    'Following': 'No following yet.',
  };

  late TabController tabController;

  bool followersTabNotLoaded = true;
  bool followingTabNotLoaded = true;

  void _initializeTabController() {
    tabController = TabController(
      length: 2, vsync: this, initialIndex: widget.pageType == 'Followers' ? 0 : 1
    );
    tabController.addListener(() async {
      if (!tabController.indexIsChanging) { 
        final currentPage = tabController.index == 0 ? 'Followers' : 'Following';
        await _loadFollowsData(page: currentPage);
      }
    });
  }

  Future<List<_FollowsProfilesData>> _fetchFollowsData(String followType) async {

    final getFollowsInfo = await FollowsGetter().getFollows(
      followType: followType,
      username: widget.username,
    );

    final usernames = getFollowsInfo['username']!;
    final profilePics = getFollowsInfo['profile_pic']!;

    return List.generate(usernames.length, (index) {
      return _FollowsProfilesData(
        username: usernames[index],
        profilePic: profilePics[index],
      );
    });

  }

  Future<void> _loadFollowsData({required String page}) async {

    try {

      if (page == 'Followers') {

        if (followersTabNotLoaded) {
          followersData.value = await _fetchFollowsData('Followers');
          followersTabNotLoaded = false;
        }

        profileActionTextNotifier.value = 'Follow';

        emptyPageMessageNotifier.value = followersData.value.isEmpty
          ? emptyMessages['Followers']! : '';

      } else if (page == 'Following') {

        if (followingTabNotLoaded) {
          followingData.value = await _fetchFollowsData('Following');
          followingTabNotLoaded = false;
        }

        final isMyProfile = userData.user.username == widget.username;

        profileActionTextNotifier.value = isMyProfile ? 'Unfollow' : 'Follow';

        emptyPageMessageNotifier.value = followingData.value.isEmpty
          ? emptyMessages['Following']! : '';
      }

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to load profiles.');
    }

  }

  Widget _buildEmptyPage() {
    return ValueListenableBuilder(
      valueListenable: emptyPageMessageNotifier,
      builder: (_, message, __) {
        return EmptyPage().customMessage(message: message);
      }
    );
  }

  Widget _buildFollowsListView({required ValueNotifier data}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.5, right: 16.5, top: 25.0),
      child: ValueListenableBuilder(
        valueListenable: data,
        builder: (_, followsData, __) {
      
          if(followsData.isEmpty) {
            return _buildEmptyPage();
          }
    
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()
            ),
            itemCount: followsData.length,
            itemBuilder: (_, index) {
              final followsUserData = followsData[index];
              return ValueListenableBuilder(
                valueListenable: profileActionTextNotifier,
                builder: (_, text, __) {
                  return AccountProfileWidget(
                    customText: text,
                    username: followsUserData.username,
                    pfpData: followsUserData.profilePic,
                  );
                },
              );
            },
          );
    
        }
      ),
    );
  }

  Widget _buildTabBarTabs() {
    return TabBarView(
      controller: tabController,
      children: [
        _buildFollowsListView(data: followersData), 
        _buildFollowsListView(data: followingData),           
      ],
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return CustomTabBar(
      controller: tabController, 
      tabAlignment: TabAlignment.center,
      tabs: const [
        Tab(text: 'Followers'),
        Tab(text: 'Following'),
      ],
    ).buildTabBar();
  }

  @override
  void initState() {
    super.initState();
    _loadFollowsData(page: widget.pageType);
    _initializeTabController();
  }

  @override
  void dispose() {
    tabController.dispose();
    followersData.dispose();
    followingData.dispose();
    profileActionTextNotifier.dispose();
    emptyPageMessageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: userData.user.username,
        bottom: _buildTabBar()
      ).buildAppBar(),
      body: _buildTabBarTabs(),
    );
  }

}