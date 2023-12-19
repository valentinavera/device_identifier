import 'dart:convert';

import 'package:encrypt/encrypt.dart';

String encryptBody(String plainText, String key){
  final iv = IV.fromLength(16);
  final encrKey = Key.fromUtf8(key);
  final encrypter = Encrypter(AES(encrKey, mode: AESMode.ecb));
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}

String descrypt(dynamic data, String key){
  final iv = IV.fromLength(16);
  final encrKey = Key.fromUtf8(key);
  final encrypter = Encrypter(AES(encrKey, mode: AESMode.ecb));
  final dataDecode = base64.decode(data as String);
  final dataEncrypt = Encrypted(dataDecode);
  final decrypted = encrypter.decrypt(dataEncrypt, iv: iv);
  return decrypted;
}
