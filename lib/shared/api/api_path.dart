class ApiPath {

  static const login = '/login';
  static const register = '/register';
  
  static const verifyUser = '/verify-user';
  static const verifyUserAuth = '$verifyUser/verify-auth';

  static const updateUser = '/update-user';
  static const updateUserAuth = '$updateUser/update-auth';
  static const updateUserAvatar = '$updateUser/update-avatar';

  static const userProfile = '/user-profile';
  static const userProfileInfoGetter = '$userProfile/get-info';
  static const userAvatarGetter = '$userProfile/get-avatar';

  static const createVent = '/create-vent';
  static const createDefaultVent = '$createVent/default-vent';
  static const createVaultVent = '$createVent/vault-vent';

  static const ventActions = '/vent-actions';
  static const deleteVent = '$ventActions/delete-vent';
  static const deleteVaultVent = '$ventActions/delete-vault-vent';
  static const likeVent = '$ventActions/like-vent';
  static const saveVent = '$ventActions/save-vent';
  static const pinVent = '$ventActions/pin-vent';
// TODO: make top variable lke ventsGetter private
  static const ventsGetter = '/vents-getter';
  static const latestVentsGetter = '$ventsGetter/latest';
  static const trendingVentsGetter = '$ventsGetter/trending';
  static const followingVentsGetter = '$ventsGetter/following';
  static const searchVentsGetter = '$ventsGetter/search';
  static const likedVentsGetter = '$ventsGetter/liked';
  static const savedVentsGetter = '$ventsGetter/saved';
  static const vaultVentsGetter = '$ventsGetter/vault';

  static const ventInfoGetter = '/vent-info-getter';
  static const ventBodyTextGetter = '$ventInfoGetter/body-text';
  static const ventMetadataGetter = '$ventInfoGetter/metadata';

  static const createComment = '/create-comment';
  static const commentActions = '/comment-actions';
  static const deleteComment = '$commentActions/delete-comment';
  static const likeComment = '$commentActions/like-comment';
  static const commentsGetter = '/comments-getter';

  static const createReply = '/create-reply';
  static const replyActions = '/reply-action';
  static const deleteReply = '$replyActions/delete-reply';
  static const likeReply = '$replyActions/like-reply';
  static const repliesGetter = '/replies-getter';

  static const profilePostsGetter = '/profile-posts-getter';
  static const profileOwnPostsGetter = '$profilePostsGetter/posts';
  static const profileSavedPostsGetter = '$profilePostsGetter/saved';

  static const searchGetter = '/search-getter';
  static const searchProfilesGetter = '$searchGetter/profiles';

  static const activityGetter = '/activity-getter';
  static const activityFollowersGetter = '$activityGetter/followers';
  static const activityRecentLikesGetter = '$activityGetter/recent-likes';
  static const activityAllTimeLikesGetter = '$activityGetter/all-time-likes';

}