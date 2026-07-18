/// Generic API result type for repository operations.
/// Implements a functional Either pattern for clean error handling.
sealed class ApiResult<T> {
  const ApiResult();

  factory ApiResult.success(T data) = ApiSuccess<T>;
  factory ApiResult.failure(ApiException error) = ApiFailure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(ApiException error) failure,
  }) {
    return switch (this) {
      ApiSuccess<T>(data: final data) => success(data),
      ApiFailure<T>(error: final error) => failure(error),
    };
  }

  R? whenOrNull<R>({
    R Function(T data)? success,
    R Function(ApiException error)? failure,
  }) {
    return switch (this) {
      ApiSuccess<T>(data: final data) => success?.call(data),
      ApiFailure<T>(error: final error) => failure?.call(error),
    };
  }

  bool get isSuccess => this is ApiSuccess<T>;
  bool get isFailure => this is ApiFailure<T>;

  T? get dataOrNull => switch (this) {
    ApiSuccess<T>(data: final data) => data,
    ApiFailure<T>() => null,
  };

  ApiException? get errorOrNull => switch (this) {
    ApiSuccess<T>() => null,
    ApiFailure<T>(error: final error) => error,
  };
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);
  final T data;
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.error);
  final ApiException error;
}

/// API exception with typed error codes.
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.code,
    this.statusCode,
    this.data,
  });

  final String message;
  final String? code;
  final int? statusCode;
  final dynamic data;

  factory ApiException.network() => const ApiException(
    message: 'Network error. Please check your connection.',
    code: 'NETWORK_ERROR',
  );

  factory ApiException.timeout() => const ApiException(
    message: 'Request timed out. Please try again.',
    code: 'TIMEOUT',
  );

  factory ApiException.unauthorized() => const ApiException(
    message: 'Session expired. Please log in again.',
    code: 'UNAUTHORIZED',
    statusCode: 401,
  );

  factory ApiException.forbidden() => const ApiException(
    message: 'You do not have permission to perform this action.',
    code: 'FORBIDDEN',
    statusCode: 403,
  );

  factory ApiException.notFound() => const ApiException(
    message: 'The requested resource was not found.',
    code: 'NOT_FOUND',
    statusCode: 404,
  );

  factory ApiException.server() => const ApiException(
    message: 'Server error. Please try again later.',
    code: 'SERVER_ERROR',
    statusCode: 500,
  );

  factory ApiException.unknown([String? message]) => ApiException(
    message: message ?? 'An unexpected error occurred.',
    code: 'UNKNOWN',
  );

  @override
  String toString() => 'ApiException($code): $message';
}
