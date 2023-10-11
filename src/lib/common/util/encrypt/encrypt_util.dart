import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:uuid/uuid.dart';

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

// 바이트 배열을 Base64 문자열로 인코딩
String b64encodeString(Uint8List bytes) {
  return base64Encode(bytes);
}

//UUID v4를 생성하여 세션 ID로 사용
String generateSessionId() {
  return Uuid().v4();
}

//주어진 길이의 랜덤 바이트를 생성하고 Base64로 인코딩
String generateRandomBytes(int length) {
  return b64encodeString(Uint8List.fromList(List<int>.generate(length, (i) => Random.secure().nextInt(256))));
}

//세션 AES 키를 생성하고 공개 키로 암호화
//암호화된 세션 AES 키는 sessionId와 함께 반환
String generateSessionKey(String sessionId, String secretKey, String iv, String base64PublicKey) {
  String sessionAesKey = 'AES_GCM\$' + secretKey + '\$' + iv;
  String encryptedSessionAesKey = encryptSessionAesKey(base64PublicKey, sessionAesKey);
  return 'v1\$' + sessionId + '\$' + encryptedSessionAesKey;
}

//주어진 공개 키(base64PublicKey)를 사용하여 세션 AES 키(sessionAesKey)를 암호화
// 먼저, 공개 키를 DER 형식에서 pc.RSAPublicKey 객체로 디코딩,
// 그런 다음, RSA OAEP 암호화 스킴을 사용하여 세션 키를 암호화하고, 결과를 Base64로 인코딩하여 반환합니다.
String encryptSessionAesKey(String base64PublicKey, String sessionAesKey) {
  pc.RSAPublicKey publicKey = _decodePublicKey(base64Decode(base64PublicKey));
  final encrypter = pc.OAEPEncoding(pc.RSAEngine())..init(true, pc.PublicKeyParameter<pc.RSAPublicKey>(publicKey));

  final encrypted = encrypter.process(utf8.encode(sessionAesKey) as Uint8List);
  return b64encodeString(encrypted);
}

//주어진 세션 ID, 시크릿 키, IV 및 데이터를 사용하여 데이터를 AES GCM 모드로 암호화
//암호화된 데이터는 sessionId와 함께 반환
String encryptData(String sessionId, String secretKey, String iv, String data) {
  final key = base64Decode(secretKey);
  final ivBytes = base64Decode(iv);

  final gcm = pc.GCMBlockCipher(pc.AESFastEngine());
  final params = pc.AEADParameters(pc.KeyParameter(key), 128, ivBytes, Uint8List(0));

  gcm.init(true, params);

  final encryptedBytes = gcm.process(utf8.encode(data) as Uint8List);
  return 'v1\$' + sessionId + '\$' + b64encodeString(encryptedBytes);
}

//주어진 시크릿 키, IV 및 암호화된 데이터를 사용하여 데이터를 AES GCM 모드로 복호화
String decryptData(String secretKey, String iv, String encryptedData) {
  final key = base64Decode(secretKey);
  final ivBytes = base64Decode(iv);

  final gcm = pc.GCMBlockCipher(pc.AESFastEngine());
  final params = pc.AEADParameters(pc.KeyParameter(key), 128, ivBytes, Uint8List(0));

  gcm.init(false, params);

  final encryptedBytes = base64Decode(encryptedData.split('\$')[2]);
  final decrypted = gcm.process(encryptedBytes);
  return utf8.decode(decrypted);
}

//DER 형식의 RSA 공개 키를 디코딩
//ASN.1 파싱을 사용하여 공개 키의 모듈러스와 지수를 추출
pc.RSAPublicKey _decodePublicKey(Uint8List publicKeyDER) {
  final asn1Parser = ASN1Parser(publicKeyDER);
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
  final publicKeyBitString = topLevelSeq.elements[1] as ASN1BitString;
  final publicKeyBytes = Uint8List.fromList(publicKeyBitString.stringValue);
  final publicKeyAsn = ASN1Parser(publicKeyBytes);
  final publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
  final modulus = publicKeySeq.elements[0] as ASN1Integer;
  final exponent = publicKeySeq.elements[1] as ASN1Integer;

  return pc.RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);
}
