import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:revent/provider/user_data_provider.dart';
import 'package:revent/ui_dialog/snack_bar.dart';
import 'package:revent/vent_query/delete_vent.dart';
import 'package:revent/vent_query/vent_actions.dart';

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
        SnackBarDialog.temporarySnack(message: 'Cannot like your own vent post');
        return;
      }

      await VentActions(title: title, creator: creator).likePost();

    } catch (err) {
      SnackBarDialog.temporarySnack(message: 'Failed to like this post');
    }

  }

  Future<void> deletePost() async {

    try {

      await DeleteVent().delete(ventTitle: title)
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

}