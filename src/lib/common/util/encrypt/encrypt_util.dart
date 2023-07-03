
import 'package:encrypt/encrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';

class EncryptUtil {
  static String getPassAPIEncrypt(String plainText, [String key = 'dmhjlpgljhkthkjw', iv = 'dmhjlpgljhkthkjw']) {
    final keyValue = Key.fromUtf8(key);
    final ivValue = IV.fromUtf8(iv);

    final encrypter = Encrypter(AES(keyValue, mode: AESMode.cbc, padding: 'PKCS7'));

    final encrypted = encrypter.encrypt(plainText, iv: ivValue);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);
    print('plainText : $plainText, encrypted.toString() ${encrypted.toString}');
    return encrypted.base64;
  }
}