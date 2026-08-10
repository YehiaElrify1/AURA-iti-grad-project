// lib/app/core/errors/app_exception.dart

class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class AppExceptionHandler {
  AppExceptionHandler._();

  static AppException from(dynamic error) {
    if (error is AppException) return error;

    final msg = error?.toString() ?? '';

    if (msg.contains('SocketException') ||
        msg.contains('Connection refused') ||
        msg.contains('NetworkException')) {
      return const AppException(
        'No internet connection. Please check your network.',
        'network_error',
      );
    }

    if (msg.contains('404')) {
      return const AppException('Resource not found.', '404');
    }

    if (msg.contains('401') || msg.contains('403')) {
      return const AppException('Access denied. Check your API key.', 'auth_error');
    }

    if (msg.contains('500')) {
      return const AppException('Server error. Please try again later.', '500');
    }

    return const AppException('Something went wrong. Please try again.');
  }
}
