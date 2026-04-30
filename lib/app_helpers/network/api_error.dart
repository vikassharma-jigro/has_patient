import 'package:equatable/equatable.dart';

enum ApiErrorType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  cancelled,
  parseError,
  unknown,
}

class ApiError extends Equatable {
  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final dynamic raw;

  const ApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.raw,
  });

  const ApiError.network()
      : type = ApiErrorType.network,
        message = 'No internet connection. Please check your network.',
        statusCode = null,
        raw = null;

  const ApiError.timeout()
      : type = ApiErrorType.timeout,
        message = 'Request timed out. Please try again.',
        statusCode = null,
        raw = null;

  const ApiError.cancelled()
      : type = ApiErrorType.cancelled,
        message = 'Request was cancelled.',
        statusCode = null,
        raw = null;

  const ApiError.parse(dynamic body)
      : type = ApiErrorType.parseError,
        message = 'Failed to parse server response.',
        statusCode = null,
        raw = body;

  // ── Bool helpers ───────────────────────────────────────────
  bool get isNetwork => type == ApiErrorType.network;
  bool get isTimeout => type == ApiErrorType.timeout;
  bool get isUnauthorized => type == ApiErrorType.unauthorized;
  bool get isForbidden => type == ApiErrorType.forbidden;
  bool get isNotFound => type == ApiErrorType.notFound;
  bool get isValidation => type == ApiErrorType.validation;
  bool get isServer => type == ApiErrorType.server;
  bool get isCancelled => type == ApiErrorType.cancelled;
  bool get isParseError => type == ApiErrorType.parseError;

  String get userMessage {
    // Strictly prioritize the API message if it exists and isn't a generic fallback
    if (message.isNotEmpty && 
        message != 'Request failed.' && 
        type != ApiErrorType.network && 
        type != ApiErrorType.timeout) {
      return message;
    }

    return switch (type) {
      ApiErrorType.network => 'No internet connection.',
      ApiErrorType.timeout => 'Request timed out. Try again.',
      ApiErrorType.unauthorized => 'Session expired. Please log in again.',
      ApiErrorType.forbidden => "You don't have permission for this action.",
      ApiErrorType.notFound => 'The requested resource was not found.',
      ApiErrorType.server => 'Server error. Please try again later.',
      ApiErrorType.cancelled => 'Request was cancelled.',
      ApiErrorType.parseError => 'Something went wrong. Please try again.',
      ApiErrorType.validation => 'Please check your input.',
      ApiErrorType.unknown => 'An unexpected error occurred.',
    };
  }

  ApiError copyWith({String? message, dynamic raw}) => ApiError(
        type: type,
        message: message ?? this.message,
        statusCode: statusCode,
        raw: raw ?? this.raw,
      );

  @override
  List<Object?> get props => [type, message, statusCode];

  @override
  String toString() =>
      'ApiError(type: $type, statusCode: $statusCode, message: $message)';
}
