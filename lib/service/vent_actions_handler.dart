import 'package:flutter/material.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/archive/delete_archive_vent.dart';
import 'package:revent/service/query/vent/delete_saved_vent.dart';
import 'package:revent/service/query/vent/delete_vent.dart';
import 'package:revent/service/query/vent/vent_actions.dart';

class VentActionsHandler {

  final BuildContext context;
  final String title;
  final String creator;

  VentActionsHandler({
    required this.context,
    required this.title,
    required this.creator
  });

  void _showTemporarySnack(String message) {
    SnackBarDialog.temporarySnack(message: message);
  }

  void _closeScreens(int count) {
    for (int i = 0; i < count; i++) {
      Navigator.pop(context);
    }
  }

  Future<void> likePost() async {

    try {

      if(creator == getIt.userProvider.user.username) {
        _showTemporarySnack("You can't like your own post.");
        return;
      }

      await VentActions(title: title, creator: creator).likePost();

    } catch (_) {
      _showTemporarySnack('Like failed.');
    }

  }

  Future<void> deletePost() async {

    try {

      await DeleteVent(title: title, creator: creator).delete().then(
        (_) {
          _showTemporarySnack('Post deleted.');
          _closeScreens(2);
        }
      );

    } catch (_) {
      _showTemporarySnack('Delete failed.');
    }

  }

  Future<void> deleteArchivedPost() async {

    try {

      await DeleteArchiveVent(title: title).delete().then(
        (_) {
          _showTemporarySnack('Archive post deleted.');
          _closeScreens(2);
        }
      );

    } catch (_) {
      _showTemporarySnack('Archive delete failed.');
    }

  }

  Future<void> unsavePost() async {

    try {

      await DeleteSavedVent(title: title, creator: creator).delete().then(
        (_) {
          _showTemporarySnack('Post removed from Saved.');
          _closeScreens(1);
        }
      );

    } catch (_) {
      _showTemporarySnack('Unsave failed.');
    }

  }

  Future<void> savePost() async {

    try {

      await VentActions(title: title, creator: creator).savePost().then(
        (_) => _showTemporarySnack('Post saved.')
      );

    } catch (_) {
      _showTemporarySnack('Save failed.');
    }

  }

}