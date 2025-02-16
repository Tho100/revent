import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashingModel {

  String computeHash(String strInput) {

    final authByteCase = utf8.encode(strInput);
    
    return sha256.convert(authByteCase).toString();

  }
  
}