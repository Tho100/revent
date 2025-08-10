import 'dart:convert';
import 'package:crypto/crypto.dart';

class HashingModel {
  // TODO: make this static
  String computeHash(String strInput) {

    final authByteCase = utf8.encode(strInput);
    
    return sha256.convert(authByteCase).toString();

  }
  
}