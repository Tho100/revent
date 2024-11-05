import 'package:flutter/material.dart';
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