class InputValidator {
  
  bool validEmailFormat(String email) {
    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+(\.[a-zA-Z]+)+$")
      .hasMatch(email);
  }

  bool validUsernameFormat(String username) {
    return RegExp(r'^(?!.*\.\.)(?!^\.)[a-zA-Z0-9._]+(?<!\.)$')
      .hasMatch(username);
  }

}