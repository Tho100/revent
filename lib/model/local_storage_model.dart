import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageModel {

  final _fileName = "info.txt";
  final _folderName = "ReventInfos";

  Future<List<String>> readLocalAccountInformation() async {

    String username = '';
    String email = '';
    String accountType = '';

    final localDir = await _retrieveLocalDirectory();

    if (localDir.existsSync()) {

      final setupFile = File('${localDir.path}/$_fileName');

      if (setupFile.existsSync()) {
        final lines = await setupFile.readAsLines();

        if (lines.length >= 3) {
          username = lines[0];
          email = lines[1];
          accountType = lines[2];
        }
      }
    }

    return [username, email, accountType];

  }

  Future<void> setupLocalAccountInformation(String username, String email, String plan) async {

    final localDir = await _retrieveLocalDirectory();
    
    if (!localDir.existsSync()) {
      localDir.createSync(recursive: true);
    }

    final setupFile = File('${localDir.path}/$_fileName');

    try {

      await setupFile.writeAsString('$username\n$email\n$plan');

    } catch (err) {
      print(err.toString());
    }

  }

  Future<void> deleteLocalData() async {

    final localDir = await _retrieveLocalDirectory();

    final filePath = File('${localDir.path}/$_fileName');

    try {

      await filePath.delete();

    } catch (err) {}

  }

  Future<Directory> _retrieveLocalDirectory() async {

    final getDirApplication = await getApplicationDocumentsDirectory();
    final setupPath = '${getDirApplication.path}/$_folderName';
    
    return Directory(setupPath);

  }

}