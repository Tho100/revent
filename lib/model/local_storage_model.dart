import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageModel {

  final _fileName = 'info.txt';
  final _searchHistoryFile = 'search_history.txt';

  final _folderName = 'ReventInfos';

  Future<void> addSearchHistory({required String text}) async {

    final localDir = await _readLocalDirectory();
    
    if (!localDir.existsSync()) {
      localDir.createSync(recursive: true);
    }

    final setupFile = File('${localDir.path}/$_searchHistoryFile');

    try {

      await setupFile.writeAsString('$text\n', mode: FileMode.append);

    } catch (err) {
      print(err.toString());
    }

  }

  Future<List<String>> readSearchHistory() async {

    final localDir = await _readLocalDirectory();

    if (!localDir.existsSync()) {
      return []; 
    }

    final setupFile = File('${localDir.path}/$_searchHistoryFile');

    if (!setupFile.existsSync()) {
      return []; 
    }

    try {

      final content = await setupFile.readAsString();

      return content.split('\n').where((line) => line.isNotEmpty).toList();

    } catch (err) {
      print(err.toString());
      return [];
    }

  }

  Future<Map<String, String>> readLocalAccountInformation() async {

    String username = '';
    String email = '';
    String accountType = '';

    final localDir = await _readLocalDirectory();

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

    return {
      'username': username, 
      'email': email, 
      'plan': accountType
    };

  }

  Future<void> setupLocalAccountInformation({
    required String username, 
    required String email, 
    required String plan
  }) async {

    final localDir = await _readLocalDirectory();
    
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

    final localDir = await _readLocalDirectory();

    final filePath = File('${localDir.path}/$_fileName');

    try {

      await filePath.delete();

    } catch (err) {
      print(err.toString());
    }

  }

  Future<Directory> _readLocalDirectory() async {

    final getDirApplication = await getApplicationDocumentsDirectory();
    final setupPath = '${getDirApplication.path}/$_folderName';
    
    return Directory(setupPath);

  }

}