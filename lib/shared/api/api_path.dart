class ApiPath {

  static const _auth = '/auth';
  static const login = '$_auth/login';
  static const register = '$_auth/register';

  static const _verify = '$_auth/verify';
  static const verifyUser = '$_verify/verify-user';
  static const verifyUserAuth = '$_verify/verify-auth';

  static const _users = '/users';
  static const _usersUpdate = '$_users/update';

  static const updateUserAuth = '$_usersUpdate/auth';
  static const updateUserAvatar = '$_usersUpdate/avatar';
  static const updateUserBio = '$_usersUpdate/bio';
  static const updateUserPronouns = '$_usersUpdate/pronouns';
  static const updateUserCountry = '$_usersUpdate/country';
  static const updateUserSocials = '$_usersUpdate/socials';

  static const _usersPrivacy = '$_users/privacy';
  static const _usersPrivacyUpdate = '$_usersPrivacy/update';

  static const makeUserPrivate = '$_usersPrivacyUpdate/private-profile';
  static const hideUserFollowing = '$_usersPrivacyUpdate/hide-following';
  static const hideUserSaved = '$_usersPrivacyUpdate/hide-saved';

  static const userPrivacyOptionsGetter = '$_usersPrivacy/all-options';

  static const _usersInfo = '$_users/about';
  static const userJoinedDateGetter = '$_usersInfo/joined-date';
  static const userCountryGetter = '$_usersInfo/country';
  static const userSocialHandlesGetter = '$_usersInfo/socials';

  static const _usersRelations = '$_users/relations';
  static const userBlockedAccountsGetter = '$_usersRelations/blocked-accounts';
  static const userBlockedStatusGetter = '$_usersRelations/blocked-status';
  static const userFollowersGetter = '$_usersRelations/followers';
  static const userFollowingGetter = '$_usersRelations/following';

  static const _usersFollows = '$_users/follows';
  static const userFollowSuggestionsGetter = '$_usersFollows/follow-suggestions';
  static const userFollowingStatusGetter = '$_usersFollows/is-following';

  static const _usersProfile = '$_users/profile';
  static const userProfileInfoGetter = '$_usersProfile/get-info';
  static const userAvatarGetter = '$_usersProfile/get-avatar';

  static const _createVent = '/vent/create';
  static const createDefaultVent = '$_createVent/default';
  static const createVaultVent = '$_createVent/vault';

  static const _ventActions = '/vent/actions';
  static const deleteVent = '$_ventActions/delete-vent';
  static const deleteVaultVent = '$_ventActions/delete-vault';
  static const likeVent = '$_ventActions/like';
  static const saveVent = '$_ventActions/save';
  static const pinVent = '$_ventActions/pin';

  static const _ventsGetter = '/vents';
  static const latestVentsGetter = '$_ventsGetter/latest';
  static const trendingVentsGetter = '$_ventsGetter/trending';
  static const followingVentsGetter = '$_ventsGetter/following';
  static const searchVentsGetter = '$_ventsGetter/search';
  static const likedVentsGetter = '$_ventsGetter/liked';
  static const savedVentsGetter = '$_ventsGetter/saved';
  static const vaultVentsGetter = '$_ventsGetter/vault';

  static const _ventInfoGetter = '/vent/info';
  static const ventBodyTextGetter = '$_ventInfoGetter/body-text';
  static const ventMetadataGetter = '$_ventInfoGetter/metadata';
  static const vaultBodyTextGetter = '$_ventInfoGetter/vault-body-text';

  static const _comment = '/comment';
  static const createComment = '$_comment/create';

  static const _commentActions = '$_comment/actions';
  static const deleteComment = '$_commentActions/delete';
  static const likeComment = '$_commentActions/like';
  static const pinComment = '$_commentActions/pin';
  static const editComment = '$_commentActions/edit';

  static const commentsGetter = '/comments';

  static const _commentOptions = '/comment/options';
  static const toggleComment = '$_commentOptions/toggle';
  static const commentStatusGetter = '$_commentOptions/get-status';

  static const _reply = '/reply';
  static const createReply = '$_reply/create';

  static const _replyActions = '$_reply/actions';
  static const deleteReply = '$_replyActions/delete';
  static const likeReply = '$_replyActions/like';
  
  static const repliesGetter = '/replies';

  static const _profilePostsGetter = '/profile-posts';
  static const profileOwnPostsGetter = '$_profilePostsGetter/posts';
  static const profileSavedPostsGetter = '$_profilePostsGetter/saved';

  static const _searchGetter = '/search';
  static const searchProfilesGetter = '$_searchGetter/profiles';

  static const _activityGetter = '/activity';
  static const activityFollowersGetter = '$_activityGetter/followers';
  static const activityRecentLikesGetter = '$_activityGetter/recent-likes';
  static const activityAllTimeLikesGetter = '$_activityGetter/all-time-likes';

  static const _idGetter = '/id-lookup';
  static const postIdGetter = '$_idGetter/post';
  static const commentIdGetter = '$_idGetter/comment';
  static const replyIdGetter = '$_idGetter/reply';
  
}