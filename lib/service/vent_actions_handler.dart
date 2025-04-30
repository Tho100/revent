import 'package:flutter/material.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/vent/pin_vent.dart';
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

  void _showErrorSnack(String message) {
    SnackBarDialog.errorSnack(message: message);
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
      _showErrorSnack('Like failed.');
    }

  }

  Future<void> deletePost() async {

    try {

      await DeleteVent(title: title).delete().then(
        (_) {
          _showTemporarySnack('Post deleted.');
          _closeScreens(2);
        }
      );

    } catch (_) {
      _showErrorSnack('Delete failed.');
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
      _showErrorSnack('Archive delete failed.');
    }

  }

  Future<void> unsavePost() async {

    try {

      await DeleteSavedVent(title: title, creator: creator).delete().then(
        (_) {
          _showTemporarySnack('Removed post from saved.');
          _closeScreens(1);
        }
      );

    } catch (_) {
      _showErrorSnack('Unsave failed.');
    }

  }

  Future<void> savePost(bool isAlreadySaved) async {

    try {

      await VentActions(title: title, creator: creator).savePost().then(
        (_) => _showTemporarySnack(isAlreadySaved ? 'Removed post from saved.' : 'Post saved.')
      );

    } catch (_) {
      _showErrorSnack('Save failed.');
    }

  }
  
  Future<void> pinPost() async {

    try {

      await PinVent(title: title).pin().then(
        (_) {
          _showTemporarySnack('Pinned post.');
          _closeScreens(1);
        }
      );

    } catch (_) {
      _showErrorSnack('Pin failed.');
    }

  }

}