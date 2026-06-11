import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:argon2/argon2.dart';

String getArgon2Hash(String password, String saltStr) {
  final saltBytes = utf8.encode(saltStr);
  final passwordBytes = utf8.encode(password);
  
  final parameters = Argon2Parameters(
    Argon2Parameters.ARGON2_i,
    Uint8List.fromList(saltBytes),
    iterations: 1,
    memory: 19456,
    lanes: 1,
    version: Argon2Parameters.ARGON2_VERSION_13,
  );
  
  final generator = Argon2BytesGenerator();
  generator.init(parameters);
  
  final result = Uint8List(32);
  generator.generateBytes(passwordBytes, result, 0, result.length);
  
  final saltBase64 = base64.encode(saltBytes).replaceAll('=', '');
  final hashBase64 = base64.encode(result).replaceAll('=', '');
  
  return '\$argon2i\$v=19\$m=19456,t=1,p=1\$$saltBase64\$$hashBase64';
}

void main() {
  test('Argon2i client hashing matches expected server value', () {
    final password = 'Test@123';
    final salt = '94fbe771-7846-437a-8691-e4c7dc5261fe';
    
    final hash = getArgon2Hash(password, salt);
    
    final expected = '\$argon2i\$v=19\$m=19456,t=1,p=1\$OTRmYmU3NzEtNzg0Ni00MzdhLTg2OTEtZTRjN2RjNTI2MWZl\$Rb71FC33w34I1NEwI5GNcGTKuGV9ELcRzR4lYytXES8';
    
    expect(hash, expected);
  });
}
