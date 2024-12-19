import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/shared/provider/user_data_provider.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/archive/delete_archive_vent.dart';
import 'package:revent/service/query/vent/delete_saved_vent.dart';
import 'package:revent/service/query/vent/delete_vent.dart';
import 'package:revent/service/query/vent/vent_actions.dart';

class CallVentActions {

  final BuildContext context;
  final String title;
  final String creator;

  CallVentActions({
    required this.context,
    required this.title,
    required this.creator
  });

  Future<void> likePost() async {

    try {

      final userData = GetIt.instance<UserDataProvider>();

      if(creator == userData.user.username) {
        SnackBarDialog.temporarySnack(message: "Can't like your own post.");
        return;
      }

      await VentActions(title: title, creator: creator).likePost();

    } catch (err) {
      SnackBarDialog.temporarySnack(message: 'Failed to like this post.');
    }

  }

  Future<void> deletePost() async {

    try {

      await DeleteVent(title: title, creator: creator).delete()
        .then((value) {
          
          SnackBarDialog.temporarySnack(message: 'Post has been deleted.');

          Navigator.pop(context);
          Navigator.pop(context);

        }
      );

    } catch (err) {
      SnackBarDialog.temporarySnack(message: 'Failed to delete this post.');
    }

  }

  Future<void> deleteArchivePost() async {

    try {

      await DeleteArchiveVent(title: title).delete()
        .then((value) {
          
          SnackBarDialog.temporarySnack(message: 'Archive has been deleted.');

          Navigator.pop(context);
          Navigator.pop(context);

        }
      );

    } catch (err) {
      SnackBarDialog.temporarySnack(message: 'Failed to delete this archive.');
    }

  }

  Future<void> removeSavedPost() async {

    try {

      await DeleteSavedVent(title: title, creator: creator).delete()
        .then((value) {
          
          SnackBarDialog.temporarySnack(message: 'Removed post from Saved.');

          Navigator.pop(context);

        }
      );

    } catch (err) {
      SnackBarDialog.temporarySnack(message: 'Failed to delete this saved post.');
    }

  }

  Future<void> savePost() async {

    try {

      await VentActions(title: title, creator: creator).savePost();

    } catch (err) {
      SnackBarDialog.errorSnack(message: 'Failed to save this post.');
    }

  }

}