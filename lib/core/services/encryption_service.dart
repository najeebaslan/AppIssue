import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:issue/core/networking/type_response.dart';

import '../../env/env.dart';

class EncryptionService {
  // The singleton instance
  static final EncryptionService _instance = EncryptionService._internal();

  // Private constructor
  EncryptionService._internal();

  // Factory constructor to return the same instance
  factory EncryptionService() {
    return _instance;
  }

  // Encryption key Base64
  final encrypt.Key _key = encrypt.Key.fromBase64(Env.encryptionKey);

  // Method to encrypt data
  String encryptData(String plainText) {
    final iv = encrypt.IV.fromLength(16); // Generate a random IV
    final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final ivBase64 = iv.base64;
    final encryptedBase64 = encrypted.base64;

    return '$ivBase64::$encryptedBase64'; // Store IV and ciphertext together
  }

  // Method to decrypt data
  ResponseResult<String, String> decryptData(String encryptedData) {
    if (encryptedData.contains('::')) {
      final parts = encryptedData.split('::');
      final iv = encrypt.IV.fromBase64(parts[0]); // Extract the IV
      final encrypted = encrypt.Encrypted.fromBase64(parts[1]);

      final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      return Success(decrypted);
    } else {
      return Failure('this backup is not valid');
    }
  }
}

// Method to generate a random key
String generateRandomKey() {
  encrypt.Key? key = encrypt.Key.fromSecureRandom(32);
  return key.base64;
}
