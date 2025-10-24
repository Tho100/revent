import 'package:revent/helper/input/input_validator.dart';
import 'package:revent/helper/test_helper.dart';
import 'package:test/test.dart';

void main() {

  final profile = TestHelper.dummyProfile(username: 'user_1231', email: 'email@gmail.com');

  group('Account Creation Validation', () {

    test('Should return true when username is valid format', () {

      final usernameIsValid = InputValidator.validateUsernameFormat(profile.username);

      expect(usernameIsValid, true);

    });

    test('Should return true when email is valid format', () {

      final emailIsValid = InputValidator.validateEmailFormat(profile.email);

      expect(emailIsValid, true);

    });

  });

}