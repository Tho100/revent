import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/query/vent/pin_vent.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/vault/delete_vault_vent.dart';
import 'package:revent/service/query/vent/unsave_vent.dart';
import 'package:revent/service/query/vent/delete_vent.dart';
import 'package:revent/service/query/vent/vent_actions.dart';

class VentActionsHandler with NavigationProviderService {

  final int postId;

  String? creator;

  VentActionsHandler({
    required this.postId,
    this.creator
  });

  void _showTemporarySnack(String message) {
    SnackBarDialog.temporarySnack(message: message);
  }

  void _showErrorSnack(String message) {
    SnackBarDialog.errorSnack(message: message);
  }

  Future<void> likePost() async {

    try {

      if (creator == getIt.userProvider.user.username) {
        _showTemporarySnack(AlertMessages.cantLikeOwnPost);
        return;
      }

      final likeVentResponse = await VentActions(postId: postId).likePost();

      if (likeVentResponse['status_code'] != 200) {
        _showErrorSnack(AlertMessages.likePostFailed);
      }

    } catch (_) {
      _showErrorSnack(AlertMessages.likePostFailed);
    }

  }

  Future<void> deletePost() async {

    try {

      final deleteVentResponse = await DeleteVent(postId: postId).delete();

      if (deleteVentResponse['status_code'] != 204) {
        _showErrorSnack(AlertMessages.deletePostFailed);
        return;
      }

      _showTemporarySnack(AlertMessages.postDeleted);
  
    } catch (_) {
      _showErrorSnack(AlertMessages.deletePostFailed);
    }

  }

  Future<void> deleteVaultPost() async {

    try {

      final deleteVaultVentResponse = await DeleteVaultVent(postId: postId).delete();

      if (deleteVaultVentResponse['status_code'] != 204) {
        _showErrorSnack(AlertMessages.deleteVaultPostFailed);
        return;
      }

      _showTemporarySnack(AlertMessages.vaultPostDeleted);

    } catch (_) {
      _showErrorSnack(AlertMessages.deleteVaultPostFailed);
    }

  }

  Future<void> unsavePost() async {

    try {

      await UnsaveVent(postId: postId).unsave();
        
      _showTemporarySnack(AlertMessages.removedSavedPost);

    } catch (_) {
      _showErrorSnack(AlertMessages.unsavePostfailed);
    }

  }

  Future<void> savePost({bool isAlreadySaved = false}) async {

    try {

      final saveVentResponse = await VentActions(postId: postId).savePost();

      if (saveVentResponse['status_code'] != 200) {
        _showErrorSnack(AlertMessages.savePostFailed);
        return;
      }

      _showTemporarySnack(
        isAlreadySaved ? AlertMessages.removedSavedPost : AlertMessages.postSaved
      );

    } catch (_) {
      _showErrorSnack(AlertMessages.savePostFailed);
    }

  }
  
  Future<void> pinPost() async {

    try {

      final pinnedPostExists = getIt.profilePostsProvider.myProfile.isPinned.contains(true);

      if (pinnedPostExists) {
        _showTemporarySnack(AlertMessages.pinnedPostExists);
        return;
      }

      final pinVentResponse = await PinVent(postId: postId).pin();

      if (pinVentResponse['status_code'] != 201) {
        _showErrorSnack(AlertMessages.pinPostFailed);
        return;
      }

      _showTemporarySnack(AlertMessages.pinnedPost);
    
    } catch (_) {
      _showErrorSnack(AlertMessages.pinPostFailed);
    }

  }

  Future<void> unpinPost() async {

    try {
      
      await PinVent(postId: postId).unpin();
      
      _showTemporarySnack(AlertMessages.removedPinnedPost);

    } catch (_) {
      _showErrorSnack(AlertMessages.unpinPostFailed);
    }

  }

}