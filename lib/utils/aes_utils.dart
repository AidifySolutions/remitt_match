import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import "package:hex/hex.dart";
import 'package:pointycastle/api.dart';
import 'package:pointycastle/export.dart' as pc;

class AesUtils {
  static final String _passphrase = '21DinMePaisaDouble';
  static final String _iteration = '1000';
  static String aesEncryptedText(String plainText){
    return base64Encode(utf8.encode(_aesCbcIterPbkdf2EncryptToBase64(_passphrase, _iteration,plainText)));
  }

 static String _aesCbcIterPbkdf2EncryptToBase64(
      String password, String iterations, String plaintext) {
    try {
      var plaintextUint8 = _createUint8ListFromString(plaintext);
      var passphrase = _createUint8ListFromString(password);
      final PBKDF2_ITERATIONS = int.tryParse(iterations);
      final salt = _generateSalt32Byte();
      pc.KeyDerivator derivator =
          new pc.PBKDF2KeyDerivator(new pc.HMac(new pc.SHA1Digest(), 64));
      pc.Pbkdf2Parameters params =
          new pc.Pbkdf2Parameters(salt, PBKDF2_ITERATIONS!, 16);
      derivator.init(params);
      final key = derivator.process(passphrase);
      final iv = _generateRandomIv();
      // final pc.ECBBlockCipher cipher =
      //     new pc.ECBBlockCipher(new pc.AESFastEngine());
      final pc.CBCBlockCipher cipher =
      new pc.CBCBlockCipher(new pc.AESFastEngine());
      pc.ParametersWithIV<pc.KeyParameter> cbcParams =
          new pc.ParametersWithIV<pc.KeyParameter>(
              new pc.KeyParameter(key), iv);
      pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null>
          paddingParams = new pc.PaddedBlockCipherParameters<
              pc.ParametersWithIV<pc.KeyParameter>, Null>(cbcParams, null);
      pc.PaddedBlockCipherImpl paddingCipher =
          new pc.PaddedBlockCipherImpl(new pc.PKCS7Padding(), cipher);
      paddingCipher.init(true, paddingParams);
      // paddingCipher.init(true, PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
      //   KeyParameter(key),
      //   null,
      // ),);
      final ciphertext = paddingCipher.process(plaintextUint8);
      final saltBase64 = _base64Encoding(salt);
      final ivBase64 = _base64Encoding(iv);
      final ciphertextBase64 = _base64Encoding(ciphertext);
      HexEncoder hex ;
      String ivHex =HEX.encode(iv);
      String saltHex = HEX.encode(salt);
      return ivHex + '::' + saltHex + '::' + ciphertextBase64;
    } catch (error) {
      return 'error in encryption $error';
    }
  }

 static String _aesCbcIterPbkdf2DecryptFromBase64(
      String password, String iterations, String data) {
    try {
      var parts = data.split('::');
      var iv = HEX.decode(parts[0]) as Uint8List;
      var salt = HEX.decode(parts[1]) as Uint8List;
      var ciphertext = _base64Decoding(parts[2]);
      var passphrase = _createUint8ListFromString(password);
      final PBKDF2_ITERATIONS = int.tryParse(iterations);
      pc.KeyDerivator derivator =
          new pc.PBKDF2KeyDerivator(new pc.HMac(new pc.SHA1Digest(), 64));
      pc.Pbkdf2Parameters params =
          new pc.Pbkdf2Parameters(salt, PBKDF2_ITERATIONS!, 16);
      derivator.init(params);
      final key = derivator.process(passphrase);
      // pc.ECBBlockCipher cipher = new pc.ECBBlockCipher(new pc.AESFastEngine());
      final pc.CBCBlockCipher cipher =
      new pc.CBCBlockCipher(new pc.AESFastEngine());
      pc.ParametersWithIV<pc.KeyParameter> cbcParams =
          new pc.ParametersWithIV<pc.KeyParameter>(
              new pc.KeyParameter(key), iv);
      pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null>
          paddingParams = new pc.PaddedBlockCipherParameters<
              pc.ParametersWithIV<pc.KeyParameter>, Null>(cbcParams, null);
      pc.PaddedBlockCipherImpl paddingCipher =
          new pc.PaddedBlockCipherImpl(new pc.PKCS7Padding(), cipher);
      paddingCipher.init(false, paddingParams);
      // paddingCipher.init(false, PaddedBlockCipherParameters<CipherParameters, CipherParameters>(
      //   KeyParameter(key),
      //   null,
      // ),);
      return new String.fromCharCodes(paddingCipher.process(ciphertext));
    } catch (error) {
      return "error in decryption $error";
    }
  }

  static Uint8List _createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  static String _base64Encoding(Uint8List input) {
    return base64.encode(input);
  }
  static Uint8List _base64Decoding(String input) {
    return base64.decode(input);
  }

  static Uint8List _generateSalt32Byte() {
    final _sGen = Random.secure();
    final _seed =
        Uint8List.fromList(List.generate(32, (n) => _sGen.nextInt(255)));
    pc.SecureRandom sec = pc.SecureRandom("Fortuna")
      ..seed(pc.KeyParameter(_seed));
    return sec.nextBytes(32);
  }

  static Uint8List _generateRandomIv() {
    final _sGen = Random.secure();
    final _seed =
        Uint8List.fromList(List.generate(32, (n) => _sGen.nextInt(255)));
    pc.SecureRandom sec = pc.SecureRandom("Fortuna")
      ..seed(pc.KeyParameter(_seed));
    return sec.nextBytes(16);
  }

}
