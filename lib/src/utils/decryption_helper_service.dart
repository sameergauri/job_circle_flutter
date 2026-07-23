// ignore_for_file: avoid_print

import 'package:encrypt/encrypt.dart' as enc;

class CryptoHelper {
  // ─── PURE AES/ECB DECRYPT ENGINE ───────────────────────────────────────────
  static String decryptECB({required String base64CipherText}) {
    try {
      String secretKey = 'plzDrN4Jq2qPjcObUxne5zHQs817Evk2';
      if (base64CipherText.isEmpty) return "";

      // 1. Key ko AES compatible bytes me convert karo
      final key = enc.Key.fromUtf8(secretKey);

      // 2. Encrypter engine setup karo strictly ECB Mode ke sath
      // Note: Hamein yahan pass karne ke liye ek dummy IV dena padta hai library syntax satisfy karne ke liye,
      // par ECB mode background me use complete IGNORE kar deta hai.
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.ecb));

      // 3. Data decrypt karke readable text return karo
      // Hamein yahan padding parameter explicitly default (PKCS7/PKCS5) rakhna hai jo Java se match karega
      final decrypted = encrypter.decrypt64(
        base64CipherText,
        iv: enc.IV.fromLength(16),
      );
      return decrypted;
    } catch (e) {
      print(
        "Decryption Failed: $e. Check if your secret key length is exactly 16, 24, or 32 chars.",
      );
      return "Error decoding";
    }
  }
}
