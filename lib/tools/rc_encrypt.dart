/*
* @overview: 加密
* @Author: rcc 
* @Date: 2022-07-18 11:14:48 
*/

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RcEncrypt {
  RcEncrypt._();

  static Encrypter? _encrypter;

  static void init({
    required String rsaKey,
  }) {
    final publicKey = RSAKeyParser().parse(rsaKey) as RSAPublicKey;

    _encrypter = Encrypter(RSA(publicKey: publicKey));
  }

  /// RSA加密
  static String encodeRsa(String text) {
    assert(_encrypter != null, 'RcEncrypt 未初始化');

    return _encrypter!.encrypt(text).base64;
  }

  /// MD5加密
  static String encodeMd5(String text) {
    final bytes = utf8.encode(text);

    return md5.convert(bytes).toString();
  }
}
