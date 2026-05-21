/// Shared form validators used across all input screens.
class Validators {
  Validators._();

  static const _emailPattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address';
    if (!RegExp(_emailPattern).hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value?.isEmpty ?? true) return 'Enter your password';
    if ((value?.length ?? 0) < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final result = Validators.password(value);
    if (result != null) return result;
    if (value != password) return 'Passwords do not match';
    return null;
  }

  static String? name(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Enter your full name';
    if ((value?.trim().length ?? 0) < 2) return 'Name is too short';
    return null;
  }

  static String? required(String? value, [String fieldName = 'This field']) {
    if (value?.trim().isEmpty ?? true) return '$fieldName is required';
    return null;
  }

  static String? phone(String? value) {
    if (value?.trim().isEmpty ?? true) return 'Enter your phone number';
    final cleaned = value!.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.length < 10) return 'Phone number is too short';
    return null;
  }

  static String? minLength(String? value, int min, [String fieldName = 'Input']) {
    if (value?.isEmpty ?? true) return '$fieldName is required';
    if (value!.length < min) return '$fieldName must be at least $min characters';
    return null;
  }

  static String? positiveNumber(String? value, [String fieldName = 'Value']) {
    if (value?.isEmpty ?? true) return '$fieldName is required';
    final number = double.tryParse(value!);
    if (number == null) return 'Enter a valid number';
    if (number <= 0) return '$fieldName must be positive';
    return null;
  }
}
