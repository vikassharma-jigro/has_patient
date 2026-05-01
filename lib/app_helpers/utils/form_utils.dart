import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ═════════════════════════════════════════════════════════════════════════════
// AppFormValidators
// ═════════════════════════════════════════════════════════════════════════════

class AppFormValidators {
  AppFormValidators._();

  /// Required field — null / blank fails.
  static FormFieldValidator<String> required({String fieldName = 'Field'}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your $fieldName';
      }
      return null;
    };
  }

  /// Email — standard RFC format.
  static FormFieldValidator<String> email() {
    return (value) {
      final input = value?.trim();
      if (input == null || input.isEmpty) return 'Please enter your email';
      if (!AppValidationLogic.emailRegExp.hasMatch(input)) {
        return 'Please enter a valid email address';
      }
      return null;
    };
  }

  /// Indian mobile (10 digits, starts 6-9).
  static FormFieldValidator<String> mobile() {
    return (value) {
      final input = value?.trim();
      if (input == null || input.isEmpty) {
        return 'Please enter your mobile number';
      }
      final sanitized = AppValidationLogic.sanitizePhone(input);
      // FIX BUG 24: Enforce Indian mobile format specifically.
      if (!AppValidationLogic.indianMobileRegExp.hasMatch(sanitized)) {
        return 'Please enter a valid 10-digit mobile number';
      }
      return null;
    };
  }

  /// Date — non-empty check.
  static FormFieldValidator<String> date() {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please select a date';
      }
      return null;
    };
  }

  /// OTP — exact length, digits only.
  static FormFieldValidator<String> otp({int length = 4}) {
    return (value) {
      final input = value?.trim();
      if (input == null || input.isEmpty) return 'Please enter the OTP';
      // FIX BUG 25: Re-enable digit-only check.
      if (!RegExp(r'^\d+$').hasMatch(input)) {
        return 'OTP must contain only digits';
      }
      if (input.length != length) return 'Please enter a $length-digit OTP';
      return null;
    };
  }

  /// Password — uppercase, lowercase, digit, special char.
  static FormFieldValidator<String> password({int minLength = 6}) {
    return (value) {
      if (value == null || value.isEmpty) return 'Please enter your password';
      if (value.length < minLength) {
        return 'Password must be at least $minLength characters long';
      }
      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return 'Password must contain at least one uppercase letter';
      }
      if (!RegExp(r'[a-z]').hasMatch(value)) {
        return 'Password must contain at least one lowercase letter';
      }
      if (!RegExp(r'\d').hasMatch(value)) {
        return 'Password must contain at least one digit';
      }
      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
        return 'Password must contain at least one special character';
      }
      return null;
    };
  }

  /// Confirm password.
  static FormFieldValidator<String> confirmPassword(
    String Function() passwordProvider,
  ) {
    return (value) {
      if (value == null || value.isEmpty) return 'Please confirm your password';
      if (value != passwordProvider()) return 'Passwords do not match';
      return null;
    };
  }

  // ── ID Proof Validators ────────────────────────────────────────────────────

  /// Aadhar — 12 digits, no all-same-digit sequence.
  /// FIX BUG 23: Added invalid-sequence check.
  static FormFieldValidator<String> aadhar() {
    return (value) {
      final input = value?.trim().replaceAll(' ', '');
      if (input == null || input.isEmpty) {
        return 'Please enter Aadhar number';
      }
      if (!RegExp(r'^\d{12}$').hasMatch(input)) {
        return 'Aadhar number must be exactly 12 digits';
      }
      // Check for trivially invalid numbers (all same digit, all zeros, etc.)
      if (RegExp(r'^(\d)\1{11}$').hasMatch(input)) {
        return 'Please enter a valid Aadhar number';
      }
      // First digit cannot be 0 or 1
      if (input[0] == '0' || input[0] == '1') {
        return 'Aadhar number cannot start with 0 or 1';
      }
      return null;
    };
  }

  /// PAN Card — format: AAAAA9999A
  static FormFieldValidator<String> pan() {
    return (value) {
      final input = value?.trim().toUpperCase();
      if (input == null || input.isEmpty) return 'Please enter PAN number';
      if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(input)) {
        return 'Please enter a valid PAN (e.g. ABCDE1234F)';
      }
      return null;
    };
  }

  /// Voter ID — format: ABC1234567 (3 letters + 7 digits = 10 chars)
  static FormFieldValidator<String> voterId() {
    return (value) {
      final input = value?.trim().toUpperCase();
      if (input == null || input.isEmpty) return 'Please enter Voter ID number';
      if (!RegExp(r'^[A-Z]{3}[0-9]{7}$').hasMatch(input)) {
        return 'Please enter a valid Voter ID (e.g. ABC1234567)';
      }
      return null;
    };
  }

  /// Indian Driving License — state code (2 letters) + RTO (2 digits) +
  /// year (4 digits) + sequence (7 digits) = 15 chars total.
  /// FIX BUG 21: Added missing Driving License validator.
  static FormFieldValidator<String> drivingLicense() {
    return (value) {
      final input = value?.trim().toUpperCase().replaceAll(' ', '');
      if (input == null || input.isEmpty) {
        return 'Please enter Driving License number';
      }
      // Format: 2 state letters + 2 RTO digits + 4 year digits + 7 seq digits
      if (!RegExp(r'^[A-Z]{2}\d{2}(19|20)\d{2}\d{7}$').hasMatch(input)) {
        return 'Please enter a valid DL number (e.g. DL0420110149646)';
      }
      return null;
    };
  }

  /// Indian Passport — format: A1234567 (1 letter + 7 digits = 8 chars)
  /// FIX BUG 22: Added missing Passport validator.
  static FormFieldValidator<String> passport() {
    return (value) {
      final input = value?.trim().toUpperCase();
      if (input == null || input.isEmpty) return 'Please enter Passport number';
      // Indian passport: 1 upper letter (not O, I) + 7 digits
      if (!RegExp(r'^[A-HJ-NP-Z][1-9]\d{6}$').hasMatch(input)) {
        return 'Please enter a valid Passport number (e.g. A1234567)';
      }
      return null;
    };
  }

  /// Dynamic ID proof validator — picks the right validator by type.
  static FormFieldValidator<String> idProof(String idProofType) {
    return (value) {
      switch (idProofType) {
        case 'Aadhar Card':
          return aadhar()(value);
        case 'PAN Card':
          return pan()(value);
        case 'Voter ID':
          return voterId()(value);
        case 'Driving License':
          return drivingLicense()(value);
        case 'Passport':
          return passport()(value);
        default:
          return required(fieldName: 'ID proof number')(value);
      }
    };
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// AppInputFormatters
// ═════════════════════════════════════════════════════════════════════════════

class AppInputFormatters {
  AppInputFormatters._();

  static final digitsOnly = FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter lengthLimit(int length) =>
      LengthLimitingTextInputFormatter(length);

  static final singleLine = FilteringTextInputFormatter.singleLineFormatter;

  static final phoneFormatter = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9+\s()-]'),
  );

  static final emailFormatter = FilteringTextInputFormatter.deny(RegExp(r'\s'));

  static final passwordFormatter = FilteringTextInputFormatter.deny(
    RegExp(r'\s'),
  );

  static final otpFormatter = FilteringTextInputFormatter.digitsOnly;

  static final nameFormatter = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z\s\-\']"),
  );

  static final addressFormatter =
      FilteringTextInputFormatter.singleLineFormatter;

  static final cityFormatter = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z\s\-]"),
  );

  static final stateFormatter = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z\s]"),
  );

  static final pincodeFormatter = FilteringTextInputFormatter.digitsOnly;

  /// Strips all whitespace from ID proof inputs.
  static final idProofFormatter = FilteringTextInputFormatter.deny(
    RegExp(r'\s'),
  );

  static final descriptionFormatter =
      FilteringTextInputFormatter.singleLineFormatter;
}

// ═════════════════════════════════════════════════════════════════════════════
// AppValidationLogic
// ═════════════════════════════════════════════════════════════════════════════

class AppValidationLogic {
  AppValidationLogic._();

  static final RegExp emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
    r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
    r"(?:\.[a-zA-Z]{2,})+$",
  );

  // FIX BUG 24: Indian mobile — starts 6-9, exactly 10 digits.
  static final RegExp indianMobileRegExp = RegExp(r'^[6-9]\d{9}$');

  // Generic international phone (kept for other uses).
  static final RegExp phoneRegExp = RegExp(r'^\+?[1-9]\d{9,14}$');

  static String sanitizePhone(String input) =>
      input.replaceAll(RegExp(r'[\s()\-+]'), '');

  static bool validateIndianNumber(String number) {
    final sanitized = sanitizePhone(number);
    // Accept with or without +91 prefix
    final bare = sanitized.startsWith('91') && sanitized.length == 12
        ? sanitized.substring(2)
        : sanitized;
    return indianMobileRegExp.hasMatch(bare);
  }

  static String normalizeIndianNumber(String rawNumber) {
    String cleaned = sanitizePhone(rawNumber);
    if (RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
      return '+91$cleaned';
    } else if (RegExp(r'^91[6-9]\d{9}$').hasMatch(cleaned)) {
      return '+$cleaned';
    } else if (RegExp(r'^0[6-9]\d{9}$').hasMatch(cleaned)) {
      return '+91${cleaned.substring(1)}';
    }
    return cleaned;
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Parses "DD/MM/YYYY" → DateTime. Returns null on failure.
DateTime? tryParseDate(String date) {
  try {
    final parts = date.split('/');
    if (parts.length == 3) {
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }
  } catch (_) {}
  return null;
}
