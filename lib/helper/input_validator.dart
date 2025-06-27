class InputValidator {

  /// Validates if the given [email] has a proper email format.
  /// - Valid characters before the '@'
  /// - A domain name after the '@'
  /// - At least one '.' in the domain part.

  static bool validEmailFormat(String email) {
    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+(\.[a-zA-Z]+)+$")
      .hasMatch(email);
  }

  /// Validates if the given [username] has a valid format.
  /// - Only letters, numbers, underscores, and dots
  /// - No consecutive dots (e.g., '..' is invalid)
  /// - Cannot start or end with a dot.

  static bool validUsernameFormat(String username) {
    return RegExp(r'^(?!.*\.\.)(?!^\.)[a-zA-Z0-9._]+(?<!\.)$')
      .hasMatch(username);
  }

}