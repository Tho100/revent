class ApiPath {

  static const login = '/login';
  static const register = '/register';
  
  static const verifyUser = '/verify-user';
  static const verifyUserAuth = '$verifyUser/verify-auth';

  static const _updateUser = '/update-user';
  static const updateUserAuth = '$_updateUser/update-auth';
  static const updateUserAvatar = '$_updateUser/update-avatar';
  static const updateUserBio = '$_updateUser/update-bio';
  static const updateUserPronouns = '$_updateUser/update-pronouns';
  static const updateUserCountry = '$_updateUser/update-country';
  static const updateUserSocials = '$_updateUser/update-socials';

  static const _userInfoGetter = '/user-info-getter';
  static const userJoinedDateGetter = '$_userInfoGetter/joined-date';
  static const userCountryGetter = '$_userInfoGetter/country';
  static const userSocialHandlesGetter = '$_userInfoGetter/socials';

  static const userRelationsGetter = '/user-relations-getter';
  static const userBlockedAccountsGetter = '$userRelationsGetter/blocked_accounts';
  static const userFollowersGetter = '$userRelationsGetter/followers';
  static const userFollowingGeter = '$userRelationsGetter/following';

  static const userFollowRelationsGetter = '/user-follow-relations-getter';
  static const userFollowSuggestionsGetter = '$userFollowRelationsGetter/follow-suggestions';
  static const userFollowingStatusGetter = '$userFollowRelationsGetter/is-following';

  static const _userProfile = '/user-profile';
  static const userProfileInfoGetter = '$_userProfile/get-info';
  static const userAvatarGetter = '$_userProfile/get-avatar';

  static const _createVent = '/create-vent';
  static const createDefaultVent = '$_createVent/default-vent';
  static const createVaultVent = '$_createVent/vault-vent';

  static const _ventActions = '/vent-actions';
  static const deleteVent = '$_ventActions/delete-vent';
  static const deleteVaultVent = '$_ventActions/delete-vault-vent';
  static const likeVent = '$_ventActions/like-vent';
  static const saveVent = '$_ventActions/save-vent';
  static const pinVent = '$_ventActions/pin-vent';

  static const _ventsGetter = '/vents-getter';
  static const latestVentsGetter = '$_ventsGetter/latest';
  static const trendingVentsGetter = '$_ventsGetter/trending';
  static const followingVentsGetter = '$_ventsGetter/following';
  static const searchVentsGetter = '$_ventsGetter/search';
  static const likedVentsGetter = '$_ventsGetter/liked';
  static const savedVentsGetter = '$_ventsGetter/saved';
  static const vaultVentsGetter = '$_ventsGetter/vault';

  static const _ventInfoGetter = '/vent-info-getter';
  static const ventBodyTextGetter = '$_ventInfoGetter/body-text';
  static const ventMetadataGetter = '$_ventInfoGetter/metadata';
  static const vaultBodyTextGetter = '$_ventInfoGetter/vault-body-text';

  static const createComment = '/create-comment';
  static const commentsGetter = '/comments-getter';

  static const _commentActions = '/comment-actions';
  static const deleteComment = '$_commentActions/delete-comment';
  static const likeComment = '$_commentActions/like-comment';
  static const pinComment = '$_commentActions/pin-comment';
  static const editComment = '$_commentActions/edit-comment';

  static const _commentOptions = '/comment-options';
  static const toggleComment = '$_commentOptions/toggle-comment';
  static const getCommentStatus = '$_commentOptions/get-comment-status';

  static const createReply = '/create-reply';
  static const repliesGetter = '/replies-getter';
  
  static const _replyActions = '/reply-action';
  static const deleteReply = '$_replyActions/delete-reply';
  static const likeReply = '$_replyActions/like-reply';

  static const _profilePostsGetter = '/profile-posts-getter';
  static const profileOwnPostsGetter = '$_profilePostsGetter/posts';
  static const profileSavedPostsGetter = '$_profilePostsGetter/saved';

  static const _searchGetter = '/search-getter';
  static const searchProfilesGetter = '$_searchGetter/profiles';

  static const _activityGetter = '/activity-getter';
  static const activityFollowersGetter = '$_activityGetter/followers';
  static const activityRecentLikesGetter = '$_activityGetter/recent-likes';
  static const activityAllTimeLikesGetter = '$_activityGetter/all-time-likes';

}