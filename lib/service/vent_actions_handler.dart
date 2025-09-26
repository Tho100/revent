import 'package:revent/global/alert_messages.dart';
import 'package:revent/helper/get_it_extensions.dart';
import 'package:revent/main.dart';
import 'package:revent/service/current_provider_service.dart';
import 'package:revent/service/query/vent/actions/like_vent.dart';
import 'package:revent/service/query/vent/actions/pin_vent.dart';
import 'package:revent/service/query/vent/actions/save_vent.dart';
import 'package:revent/shared/provider_mixins.dart';
import 'package:revent/shared/widgets/ui_dialog/snack_bar.dart';
import 'package:revent/service/query/vent/vault/delete_vault_vent.dart';
import 'package:revent/service/query/vent/actions/delete_vent.dart';

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

  Map<String, dynamic> _getVentProvider() {

    final currentProvider = CurrentProviderService(postId: postId).getProvider();

    return currentProvider;

  }

  Future<void> likePost() async {

    try {

      if (creator == getIt.userProvider.user.username) {
        _showTemporarySnack(AlertMessages.cantLikeOwnPost);
        return;
      }

      final likeVentResponse = await LikeVent(
        postId: postId, ventProvider: _getVentProvider()
      ).likePost();

      if (likeVentResponse['status_code'] != 200) {
        _showErrorSnack(AlertMessages.likePostFailed);
      }

    } catch (_) {
      _showErrorSnack(AlertMessages.likePostFailed);
    }

  }

  Future<void> savePost({bool isAlreadySaved = false}) async {

    try {
// TODO: Fix icon doesn't update when post is saved
      final saveVentResponse = await SaveVent(
        postId: postId, ventProvider: _getVentProvider()
      ).savePost();

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

  Future<void> unsavePost() async {

    try {

      await SaveVent(
        postId: postId, ventProvider: _getVentProvider()
      ).unsavePost();
        
      _showTemporarySnack(AlertMessages.removedSavedPost);

    } catch (_) {
      _showErrorSnack(AlertMessages.unsavePostfailed);
    }

  }
  
  Future<void> pinPost() async {

    try {

      final pinnedPostExists = getIt.profilePostsProvider.myProfile.isPinned.contains(true);

      if (pinnedPostExists) {
        _showTemporarySnack(AlertMessages.pinnedPostExists);
        return;
      }

      final pinVentResponse = await PinVent(postId: postId).pinPost();

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
      
      await PinVent(postId: postId).unpinPost();
      
      _showTemporarySnack(AlertMessages.removedPinnedPost);

    } catch (_) {
      _showErrorSnack(AlertMessages.unpinPostFailed);
    }

  }

  Future<void> deletePost() async {

    try {

      final deleteVentResponse = await DeleteVent(postId: postId).deletePost();

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

}