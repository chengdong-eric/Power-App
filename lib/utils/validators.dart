String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password cannot be empty';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters long.';
  }

  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter.';
  }

  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Password must contain at least one lowercase letter.';
  }

  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one digit.';
  }

  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least one digit.';
  }

  return null;
}

String? validateEmail(String? value) {
  if (value == null || !value.contains('@') || !value.contains('.')) {
    return 'Please enter a valid email address.';
  }
  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.trim().length < 4) {
    return 'Username must be at least 4 characters long.';
  }
  return null;
}
