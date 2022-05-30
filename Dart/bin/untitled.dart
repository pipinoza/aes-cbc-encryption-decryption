

import 'package:crypto/crypto.dart' ;
import 'package:encrypt/encrypt.dart' as EncryptPack;
import 'dart:convert';


void main() async{

  final sharedKey= '11111111111111111111111111111111';
  final base64EncryptedTextFromLaravel= 'eyJpdiI6IlVCN2hpZ0xVVXpIR0ZCOS93bTFHOVE9PSIsInZhbHVlIjoiL2hCNGQxZyt6ZldJTnE2N0xmWlgxZz09IiwibWFjIjoiNmIyMTYxZWRiNWZjOTg1MjFiMmMxMTVkZGUxODY1YTFkMzE4YWFmOGVkNTdmNmFiMmZkYjg3YWJhYjMxMjgyMSIsInRhZyI6IiJ9';

print('begin base64 string decryption received from laravel');
  await decryptLaravel(base64EncryptedTextFromLaravel,
    sharedKey);

  print('begin string encryption for laravel');
  encryptForLaravel('text to encrypt',sharedKey);
}

 Future <void> decryptLaravel(String payload, String secret) async {
  final encryptedDataFromLaravel=  EncryptPack.Encrypted.from64(base64.normalize(payload));
  final encryptedDataFromLaravelJson= jsonDecode( utf8.decode(encryptedDataFromLaravel.bytes));
  final ivFromLaravel = encryptedDataFromLaravelJson['iv'];
  final dataToDecryptFromLaravel = encryptedDataFromLaravelJson['value'];
  final macFromLaravel = encryptedDataFromLaravelJson['mac'];
  final stringToHash = ivFromLaravel+dataToDecryptFromLaravel;
  final hmacSha256 = new Hmac(sha256, utf8.encode(secret)); // HMAC-SHA256
  final hash =  hmacSha256.convert(utf8.encode(stringToHash));

  if( macFromLaravel.toString()==hash.toString() ){

    final  EncryptPack.Key keyObj = EncryptPack.Key.fromUtf8(secret);
    final iv = EncryptPack.IV.fromBase64(ivFromLaravel);
    final encryptor = EncryptPack.Encrypter(EncryptPack.AES(keyObj, mode: EncryptPack.AESMode.cbc));

    print( 'Decrypted Text: '+ encryptor.decrypt64(dataToDecryptFromLaravel, iv: iv));

  } else{
    print('mac is not valid!');
  }





}

  Future <void> encryptForLaravel(String data, String secret) async{
  final key = EncryptPack.Key.fromUtf8(secret);
  final iv = EncryptPack.IV.fromSecureRandom(16);

  final encryptor = EncryptPack.Encrypter(EncryptPack.AES(key, mode: EncryptPack.AESMode.cbc));
  final encrypted = encryptor.encrypt(data, iv: iv);
  final stringToHash = iv.base64+encrypted.base64;
  final hmacSha256 = new Hmac(sha256, utf8.encode(secret)); // HMAC-SHA256
  final hash =  hmacSha256.convert(utf8.encode(stringToHash));

  final
  payload = jsonEncode( {
    'iv' : iv.base64,
    'value' : encrypted.base64,
    'mac' : hash.toString(),
    'tag' : ''
  }
  );

  print ('Encrypted Text: ' + base64.encode(utf8.encode(payload)));


}
