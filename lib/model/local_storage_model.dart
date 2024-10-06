import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:revent/security/encryption_model.dart';

class LocalStorageModel {

  final encryption = EncryptionClass();

  final _fileName = "info.txt";
  final _folderName = "FlowStorageInfos";
  final _accountPlanFolderName = "FlowStorageAccountInfoPlan";

  final _accountUsernamesFolderName = "FlowStorageAccountInfo";
  final _accountEmailFolderName = "FlowStorageAccountInfoEmail";

  Future<List<String>> readLocalAccountInformation() async {
    
    String username = '';
    String email = '';
    String accountType = '';

    final localDir = await _retrieveLocalDirectory();

    if (localDir.existsSync()) {
      final setupFiles = File('${localDir.path}/$_fileName');

      if (setupFiles.existsSync()) {
        final lines = await setupFiles.readAsLines();

        if (lines.length >= 2) {
          username = lines[0];
          email = lines[1];
          accountType = lines[2];
        }
      }
    }

    List<String> accountInfo = [];

    accountInfo.add(encryption.decrypt(username));
    accountInfo.add(encryption.decrypt(email));
    accountInfo.add(accountType);

    return accountInfo;

  }

  Future<void> setupLocalAutoLogin(String username, String email, String accountType) async {

    final localDir = await _retrieveLocalDirectory();

    if (email.isNotEmpty && email.isNotEmpty) {

      if (localDir.existsSync()) {
        localDir.deleteSync(recursive: true);
      }

      localDir.createSync();

      final setupFiles = File('${localDir.path}/$_fileName');

      try {
        
        if (setupFiles.existsSync()) {
          setupFiles.deleteSync();
        }

        setupFiles.writeAsStringSync(
          "${EncryptionClass().encrypt(username)}\n${EncryptionClass().encrypt(email)}\n$accountType");

      } catch (err) { }

    } 

  }

  Future<void> _deleteLocalData(String customFolder, String data) async {

    if (data.isEmpty) {
      return;
    }

    final localDir = await _retrieveLocalDirectory(
      customFolder: customFolder
    );

    final filePath = File('${localDir.path}/$_fileName');

    try {

      await filePath.delete();

    } catch (err) { }

  }

  Future<void> deleteLocalAccountUsernames(String username) async {
    await _deleteLocalData(_accountUsernamesFolderName, username);
  }

  Future<void> deleteLocalAccountEmails(String email) async {
    await _deleteLocalData(_accountEmailFolderName, email);
  }

  Future<void> deleteLocalAccountPlans(String plan) async {
    await _deleteLocalData(_accountPlanFolderName, plan);
  }

  Future<Directory> _retrieveLocalDirectory({String? customFolder}) async {

    final folderName = customFolder ?? _folderName;

    final getDirApplication = await getApplicationDocumentsDirectory();
    final setupPath = '${getDirApplication.path}/$folderName';
    
    return Directory(setupPath);

  }

}