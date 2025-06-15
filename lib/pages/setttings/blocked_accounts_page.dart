import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/service/query/user/user_block_getter.dart';
import 'package:revent/shared/widgets/account_profile.dart';
import 'package:revent/shared/widgets/app_bar.dart';

class _BlockedAccountsData {
  
  final String username;
  final Uint8List profilePic;

  _BlockedAccountsData({
    required this.username,
    required this.profilePic,
  });

}

class BlockedAccountsPage extends StatefulWidget {

  const BlockedAccountsPage({super.key});

  @override
  State<BlockedAccountsPage> createState() => _BlockedAccountsPageState();

}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {

  final ValueNotifier<List<_BlockedAccountsData>> blockedAccountsData = ValueNotifier([]);

  Future<void> _loadBlockedAccounts() async {

    final blockedAccountsInfo = await UserBlockGetter(
      username: getIt.userProvider.user.username
    ).getBlockedAccounts();
  
    final usernames = blockedAccountsInfo['username'] as List<String>;
    final profilePics = blockedAccountsInfo['profile_pic'] as List<Uint8List>;

    blockedAccountsData.value = List.generate(usernames.length, (index) {
      return _BlockedAccountsData(
        username: usernames[index], 
        profilePic: profilePics[index]
      );
    });

  }

  Future<void> _onUnblockPressed({required String username}) async {
    await UserActions(username: username).blockUser(block: false).then(
      (_) => blockedAccountsData.value = List.from(blockedAccountsData.value)..removeWhere(
        (data) => data.username == username
      )
    );
  }

  Widget _buildEmptyPage() {
    return NoContentMessage().customMessage(
      message: 'No blocked accounts.'
    );
  }

  Widget _buildAccountsListView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.5, right: 16.5, top: 25.0),
      child: ValueListenableBuilder(
        valueListenable: blockedAccountsData,
        builder: (_, blockedData, __) {
          
          if (blockedData.isEmpty) {
            return _buildEmptyPage();
          }
    
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemCount: blockedData.length,
            itemBuilder: (_, index) {

              final blockedUserData = blockedData[index];

              return AccountProfileWidget(
                customText: 'Unblock',
                username: blockedUserData.username,
                pfpData: blockedUserData.profilePic,
                onPressed: () async => await _onUnblockPressed(username: blockedUserData.username)
              );

            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadBlockedAccounts();
  }

  @override
  void dispose() {
    blockedAccountsData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: 'Blocked Accounts'
      ).buildAppBar(),
      body: _buildAccountsListView(),
    );
  }

}