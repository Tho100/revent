import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthModel { // TODO: Rename to hash model

  String computeHash(String strInput) {

    final authByteCase = utf8.encode(strInput);
    final authHashCase = sha256.convert(authByteCase);
    final toStringHash = authHashCase.toString().toUpperCase();
    
    return toStringHash;

  }
  
}