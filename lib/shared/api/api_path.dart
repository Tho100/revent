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
  static const likeVent = '$ventActions/delete-vent';
  static const saveVent = '$ventActions/delete-vent';

}