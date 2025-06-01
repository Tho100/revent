import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageModel {

  final _userInfoFile = 'info.txt';
  final _userThemeFile = 'theme_info.txt';
  final _searchHistoryFile = 'search_history.txt';
  final _currentHomeTabFile = 'home_tab.txt';

  final _folderName = 'ReventInfos';

  Future<void> setupThemeInformation({required String theme}) async {

    final localDir = await _readLocalDirectory();
    
    if (!localDir.existsSync()) {
      localDir.createSync(recursive: true);
    }

    final setupFile = File('${localDir.path}/$_userThemeFile');

    try {

      await setupFile.writeAsString(theme);

    } catch (_) {
      return;
    }

  }

  Future<String> readThemeInformation() async {
    
    final localDir = await _readLocalDirectory();

    if (!localDir.existsSync()) {
      return 'dark'; 
    }

    final setupFile = File('${localDir.path}/$_userThemeFile');

    if (!setupFile.existsSync()) {
      return 'dark'; 
    }

    try {

      return await setupFile.readAsString();

    } catch (_) {
      return 'dark';
    }

  }

  Future<void> addSearchHistory({required String text}) async {

    final localDir = await _readLocalDirectory();
    
    if (!localDir.existsSync()) {
      localDir.createSync(recursive: true);
    }

    final setupFile = File('${localDir.path}/$_searchHistoryFile');

    try {

      final searchHistory = await readSearchHistory();

      if (!searchHistory.contains(text)) {
        await setupFile.writeAsString('$text\n', mode: FileMode.append);
      }

    } catch (_) {
      return;
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

    } catch (_) {
      return [];
    }

  }

  Future<void> deleteSearchHistory({required String textToDelete}) async {

    final localDir = await _readLocalDirectory();

    if (!localDir.existsSync()) {
      return; 
    }

    final setupFile = File('${localDir.path}/$_searchHistoryFile');

    if (!setupFile.existsSync()) {
      return; 
    }

    try {

      final lines = await setupFile.readAsLines();

      final updatedLines = lines.where((line) => line.trim() != textToDelete).toList();

      await setupFile.writeAsString('${updatedLines.join('\n')}\n');

    } catch (_) {
      return;
    }

  }

  Future<void> deleteAllSearchHistory() async {

    final localDir = await _readLocalDirectory();

    if (!localDir.existsSync()) {
      return; 
    }

    final setupFile = File('${localDir.path}/$_searchHistoryFile');

    if (!setupFile.existsSync()) {
      return; 
    }

    try {

      await setupFile.delete();

    } catch (_) {
      return;
    }

  }

  Future<Map<String, String>> readAccountInformation() async {

    String username = '';
    String email = '';

    final localDir = await _readLocalDirectory();

    if (localDir.existsSync()) {

      final setupFile = File('${localDir.path}/$_userInfoFile');

      if (setupFile.existsSync()) {

        final lines = await setupFile.readAsLines();

        if (lines.length >= 2) {
          username = lines[0];
          email = lines[1];
        }

      }
      
    }

    return {
      'username': username, 
      'email': email, 
    };

  }

  Future<void> setupAccountInformation({
    required String username, 
    required String email, 
  }) async {

    final localDir = await _readLocalDirectory();
    
    if (!localDir.existsSync()) {
      localDir.createSync(recursive: true);
    }

    final setupFile = File('${localDir.path}/$_userInfoFile');

    try {

      await setupFile.writeAsString('$username\n$email');

    } catch (_) {
      return;
    }

  }

  Future<void> setupCurrentHomeTab({required String tab}) async {

    final localDir = await _readLocalDirectory();
    
    final setupFile = File('${localDir.path}/$_currentHomeTabFile');

    if (!await setupFile.exists()) {
      await setupFile.create();
    }

    try {

      await setupFile.writeAsString(tab);

    } catch (_) {
      return;
    }

  }

  Future<String> readCurrentHomeTab() async {
  
    final localDir = await _readLocalDirectory();
    
    final setupFile = File('${localDir.path}/$_currentHomeTabFile');

    if(await setupFile.exists()) {
      return await setupFile.readAsString();
    }

    return 'Latest';

  }

  Future<void> deleteLocalData() async {
    
    final localDir = await _readLocalDirectory();

    final fileNames = [
      _userInfoFile,
      _userThemeFile
    ];

    try {

      for (final name in fileNames) {

        final file = File('${localDir.path}/$name');

        if (await file.exists()) {
          await file.delete();
        }

      }

    } catch (_) {
      return;
    }

  }

  Future<Directory> _readLocalDirectory() async {

    final getDirApplication = await getApplicationDocumentsDirectory();
    final setupPath = '${getDirApplication.path}/$_folderName';
    
    return Directory(setupPath);

  }

}