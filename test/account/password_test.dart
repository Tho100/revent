import 'package:revent/security/hash_model.dart';
import 'package:test/test.dart';

void main() {

  group('Password Validation', () {

    const pass = 'abc123';

    test('Should return true when pass has minimum length', () {

      const minLength = 5;

      expect(pass.length, greaterThanOrEqualTo(minLength));

    });

    test('Should return true when pass hashed successfully', () {

      final passHash = HashingModel().computeHash(pass);

      // Hash value for [pass] "abc123"
      const expectedHash = '6ca13d52ca70c883e0f0bb101e425a89e8624de51db2d2392593af6a84118090'; 

      expect(passHash, expectedHash);

    });

    test('Different inputs produce different hashes', () {

      final hash1 = HashingModel().computeHash('one');
      final hash2 = HashingModel().computeHash('two');
      
      expect(hash1 != hash2, true);

    });

  });

}