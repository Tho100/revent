class ApiPath {

  static const login = '/login';
  static const register = '/register';
  
  static const verifyUser = '/verify-user';
  static const verifyUserAuth = '$verifyUser/verify-auth';

  static const updateUser = '/update-user';
  static const updateUserAuth = '$updateUser/update-auth';

  static const createVent = '/create-vent';
  static const createDefaultVent = '$createVent/default-vent';
  static const createVaultVent = '$createVent/vault-vent';

  static const ventActions = '/vent-actions';
  static const deleteVent = '$ventActions/delete-vent';
  static const deleteVaultVent = '$ventActions/delete-vault-vent';
  static const likeVent = '$ventActions/like-vent';
  static const saveVent = '$ventActions/save-vent';
  static const pinVent = '$ventActions/pin-vent';

  static const ventsGetter = '/vents-getter';
  static const latestVentsGetter = '$ventsGetter/latest';
  static const trendingVentsGetter = '$ventsGetter/trending';
  static const followingVentsGetter = '$ventsGetter/following';
  static const searchVentsGetter = '$ventsGetter/search';

  static const createComment = '/create-comment';

  static const commentActions = '/comment-actions';
  static const deleteComment = '$commentActions/delete-comment';

}