import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorageModel {

  final _userInfoFile = 'info.txt';
  final _userThemeFile = 'theme_info.txt';
  final _userSocialHandles = 'socials_info.txt';
  final _searchHistoryFile = 'search_history.txt';

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

      await setupFile.writeAsString('$text\n', mode: FileMode.append);

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

  Future<Map<String, String>> readLocalAccountInformation() async {

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

  Future<void> setupLocalAccountInformation({
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

  Future<void> setupLocalSocialHandles({required Map<String, String> socialHandles}) async {

    final localDir = await _readLocalDirectory();
    
    final setupFile = File('${localDir.path}/$_userSocialHandles');

    try {

      final existingHandles = await readLocalSocialHandles();

      existingHandles.addAll(socialHandles);

      final filteredHandles = existingHandles.entries
        .map((entry) => '${entry.key} ${entry.value}')
        .join('\n');

      await setupFile.writeAsString(filteredHandles);

    } catch (_) {
      return;
    }

  }

  Future<Map<String, String>> readLocalSocialHandles() async {

    final localDir = await _readLocalDirectory();
    
    final setupFile = File('${localDir.path}/$_userSocialHandles');

    if (!await setupFile.exists()) return {};
    
    try {

      final content = await setupFile.readAsString();
      
      final socialHandles = {
        for (var line in content.split('\n'))
          if (line.trim().isNotEmpty)
            line.split(' ')[0]: line.split(' ').sublist(1).join(' ')
      };

      return {
        'instagram': socialHandles['instagram'] ?? '',
        'twitter': socialHandles['twitter'] ?? '',
        'tiktok': socialHandles['tiktok'] ?? '',
      };

    } catch (_) {
      return {};
    }

  }

  Future<void> deleteLocalData() async {

    final localDir = await _readLocalDirectory();

    final userInfo = File('${localDir.path}/$_userInfoFile');
    final userSocialHandles = File('${localDir.path}/$_userSocialHandles');
    final themeInfo = File('${localDir.path}/$_userThemeFile');

    try {

      await userInfo.delete();

      if(await userSocialHandles.exists()) {
        await userSocialHandles.delete();
      }

      if(await themeInfo.exists()) {
        await themeInfo.delete();
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