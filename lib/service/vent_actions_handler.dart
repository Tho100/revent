import 'package:flutter/material.dart';
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
// TODO: Put those messages in alert-message
  Future<void> likePost() async {

    try {

      if (creator == getIt.userProvider.user.username) {
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

      await DeleteVent(title: title).delete();

      _showTemporarySnack('Post deleted.');
      _closeScreens(1);

    } catch (_) {
      _showErrorSnack('Delete failed.');
    }

  }

  Future<void> deleteVaultPost() async {

    try {

      await DeleteVaultVent(title: title).delete();

      _showTemporarySnack('Vault post deleted.');
      _closeScreens(2);

    } catch (_) {
      _showErrorSnack('Vault delete failed.');
    }

  }

  Future<void> unsavePost() async {

    try {

      await DeleteSavedVent(title: title, creator: creator).delete();
        
      _showTemporarySnack('Removed post from saved.');
      _closeScreens(1);

    } catch (_) {
      _showErrorSnack('Unsave failed.');
    }

  }

  Future<void> savePost({bool isAlreadySaved = false}) async {

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

      if (getIt.profilePostsProvider.myProfile.isPinned.contains(true)) {
        _closeScreens(1);
        _showTemporarySnack('You already have pinned post.');
        return;
      }

      await PinVent(title: title).pin();

      _showTemporarySnack('Pinned post.');
      _closeScreens(1);
    
    } catch (_) {
      _showErrorSnack('Pin failed.');
    }

  }

  Future<void> unpinPost() async {

    try {

      await PinVent(title: title).pin();
      
      _showTemporarySnack('Removed post from pinnned.');
      _closeScreens(1);

    } catch (_) {
      _showErrorSnack('Unpin failed.');
    }

  }

}