
mixin FieldValidationMixin {


  bool isNotNullEmpty(String fieldValue) =>
      fieldValue!=null && fieldValue.isNotEmpty;


  String isFieldEmpty(String fieldValue) =>
      fieldValue?.isEmpty ??
      "Cannot be empty";

  String validateEmailAddress(String email) {
    if (email == null) {
      return "Cannot be empty";
    }

    bool isValid = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);

    return isValid
        ?  null
        : "Enter a valid email.";
  }

  String validatePassword(String password) {
    if (password == null) {
      return "Cannot be empty";
    }

    bool isValid = RegExp(r'(?=.*[A-Z])').hasMatch(password);

    if (isValid == false) {
      return "Should contain at least one upper case";
    }

    isValid = RegExp(r'(?=.*[a-z])').hasMatch(password);

    if (isValid == false) {
      return "Should contain at least one lower case";
    }

    isValid = RegExp(r'(?=.*?[0-9])').hasMatch(password);

    if (isValid == false) {
      return "Should contain at least one digit";
    }

    isValid = RegExp(r'(?=.*?[!@#\$&*~])').hasMatch(password);

    if (isValid == false) {
      return "Should contain at least one Special character";
    }

    if (password.length < 8) {
      return "Should contain minimum 8 characters";
    }

    if (password.length > 20) {
      return "Should contain maximum 20 characters";
    }

    return null;
  }

  String validatePhone(String phone) {
    if (phone == null) {
      return "Cannot be empty";
    }
    if (phone.length < 10) {
      return "Should contain minimum 10 characters";
    }

    if (phone.length > 10) {
      return  "Should contain maximum 10 characters";
    }

    return null;
  }


  String validateUserName(String userName) {
    if (userName == null) {
      return "Cannot be empty";
    }
    if (userName.length < 3) {
      return "Should contain minimum 3 characters";
    }

    if (userName.length > 25) {
      return "Should contain maximum 25 characters";
    }

    return null;
  }






  String validateDob(String dob) {
    if (dob == null || dob.length<3) {
      return "Cannot be empty";
    }


    return null;
  }


  String validateEmailOrPhone(String emailOrPhone, phoneEmailMode) {
    if (phoneEmailMode) {
      return validatePhone(emailOrPhone);
    } else {
      return validateEmailAddress(emailOrPhone);
    }
  }
}
