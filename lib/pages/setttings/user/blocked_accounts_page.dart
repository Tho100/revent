import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/widgets/no_content_message.dart';
import 'package:revent/service/user/actions_service.dart';
import 'package:revent/service/user/block_service.dart';
import 'package:revent/shared/widgets/profile/title_widget.dart';
import 'package:revent/shared/widgets/app_bar.dart';
import 'package:revent/shared/widgets/dialog/snack_bar.dart';

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

  ValueNotifier<List<_BlockedAccountsData>> blockedAccountsData = ValueNotifier([]);

  Future<void> _initializeBlockedAccounts() async {

    final blockedAccountsInfo = await UserBlockService(
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

  void _removeFromBlockedList(String username) {
    blockedAccountsData.value = List.from(blockedAccountsData.value)..removeWhere(
      (data) => data.username == username
    );
  }

  Future<void> _onUnblockPressed({required String username}) async {

    final toggleUnblockResponse = await UserActions(username: username).toggleBlockUser();

    if (toggleUnblockResponse['status_code'] != 200) {
      SnackBarDialog.errorSnack(message: AlertMessages.defaultError);
      return;
    }

    _removeFromBlockedList(username);

  }

  Widget _buildListView(List<_BlockedAccountsData> blockedData) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: blockedData.length,
      itemBuilder: (_, index) {

        final blockedUserData = blockedData[index];

        return UserProfileTitleWidget(
          customText: 'Unblock',
          username: blockedUserData.username,
          pfpData: blockedUserData.profilePic,
          onPressed: () async => await _onUnblockPressed(username: blockedUserData.username)
        );

      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.5, right: 16.5, top: 25.0),
      child: ValueListenableBuilder(
        valueListenable: blockedAccountsData,
        builder: (_, blockedData, __) {
          return blockedData.isEmpty 
            ? _buildNoBlockedAccounts()
            : _buildListView(blockedData);
        },
      ),
    );
  }

  Widget _buildNoBlockedAccounts() {
    return NoContentMessage().customMessage(
      message: 'No blocked accounts.'
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeBlockedAccounts();
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
      body: _buildBody(),
    );
  }

}