import 'package:flutter/material.dart';
import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/vent/pin_vent.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/vault/delete_vault_vent.dart';
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

      if (creator == getIt.userProvider.user.username) {
        _showTemporarySnack(AlertMessages.cantLikeOwnPost);
        return;
      }

      await VentActions(title: title, creator: creator).likePost();

    } catch (_) {
      _showErrorSnack(AlertMessages.likePostFailed);
    }

  }

  Future<void> deletePost() async {

    try {

      await DeleteVent(title: title).delete();

      _showTemporarySnack(AlertMessages.postDeleted);
      _closeScreens(1);

    } catch (_) {
      _showErrorSnack(AlertMessages.deletePostFailed);
    }

  }

  Future<void> deleteVaultPost() async {

    try {

      await DeleteVaultVent(title: title).delete();

      _showTemporarySnack(AlertMessages.vaultPostDeleted);
      _closeScreens(2);

    } catch (_) {
      _showErrorSnack(AlertMessages.deleteVaultPostFailed);
    }

  }

  Future<void> unsavePost() async {

    try {

      await DeleteSavedVent(title: title, creator: creator).delete();
        
      _showTemporarySnack(AlertMessages.removedSavedPost);
      _closeScreens(1);

    } catch (_) {
      _showErrorSnack(AlertMessages.unsavePostfailed);
    }

  }

  Future<void> savePost({bool isAlreadySaved = false}) async {

    try {

      await VentActions(title: title, creator: creator).savePost().then(
        (_) => _showTemporarySnack(isAlreadySaved ? AlertMessages.removedSavedPost : AlertMessages.postSaved)
      );

    } catch (_) {
      _showErrorSnack(AlertMessages.savePostFailed);
    }

  }
  
  Future<void> pinPost() async {

    try {

      final pinnedPostExists = getIt.profilePostsProvider.myProfile.isPinned.contains(true);

      if (pinnedPostExists) {
        _closeScreens(1);
        _showTemporarySnack(AlertMessages.pinnedPostExists);
        return;
      }

      await PinVent(title: title).pin();

      _showTemporarySnack(AlertMessages.pinnedPost);
      _closeScreens(1);
    
    } catch (_) {
      _showErrorSnack(AlertMessages.pinPostFailed);
    }

  }

  Future<void> unpinPost() async {

    try {
      
      await PinVent(title: title).unpin();
      
      _showTemporarySnack(AlertMessages.removedPinnedPost);
      _closeScreens(1);

    } catch (_) {
      _showErrorSnack(AlertMessages.unpinPostFailed);
    }

  }

}