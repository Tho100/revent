import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:revent/helper/navigator_extension.dart';
import 'package:revent/service/query/user/user_actions.dart';
import 'package:revent/shared/widgets/bottomsheet/user/about_profile.dart';
import 'package:revent/shared/widgets/bottomsheet/user/report_user_bottomsheet.dart';
import 'package:revent/shared/widgets/bottomsheet/user/user_actions.dart';
import 'package:revent/shared/widgets/ui_dialog/alert_dialog.dart';

class UserProfileActions {
  
  final BuildContext context;

  UserProfileActions({required this.context});

  void showUserActions({
    required String username,
    required String pronouns,
    required Uint8List pfpData,
    required Future<String> Function() loadJoinedDate,
    required Future<String> Function() loadCountry
  }) {
    BottomsheetUserActions().buildBottomsheet(
      context: context,
      aboutProfileOnPressed: () => _onAboutProfilePressed(
        username, pronouns, pfpData, loadJoinedDate, loadCountry
      ),
      blockOnPressed: () => _onBlockPressed(username),
      reportOnPressed: _onReportPressed,
    );
  }

  Future<void> _onAboutProfilePressed(
    String username, 
    String pronouns, 
    Uint8List pfpData, 
    Future<String> Function() loadJoinedDate,
    Future<String> Function() loadCountry,
  ) async {

    Navigator.pop(context);

    final joinedDate = await loadJoinedDate();
    final country = await loadCountry();

    if (context.mounted) {
      BottomsheetAboutProfile().buildBottomsheet(
        context: context,
        username: username,
        pronouns: pronouns,
        pfpData: pfpData,
        joinedDate: joinedDate,
        country: country,
      );
    }

  }

  void _onBlockPressed(String username) {
    context.popAndRun(() {
      CustomAlertDialog.alertDialogCustomOnPress(
        message: 'Block @$username?',
        buttonMessage: 'Block',
        onPressedEvent: () async => await _confirmBlockUser(username),
      );
    });
  }

  void _onReportPressed() {
    context.popAndRun(
      () => ReportUserBottomsheet().buildBottomsheet(context: context)
    );
  }

  Future<void> _confirmBlockUser(String username) async {
    await UserActions(username: username).toggleBlockUser()
      .then((_) => Navigator.pop(context))
      .then((_) => Navigator.pop(context));
  }

}
