import 'package:ecommerce_app/src/exceptions/app_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:rive_bloc/rive_bloc.dart';
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stackTrace) {
    // * This can be replaced with a call to a crash reporting tool of choice
    debugPrint('$error, $stackTrace');
  }

  void logAppException(AppException exception) {
    // * This can be replaced with a call to a crash reporting tool of choice
    debugPrint('$exception');
  }
}

// Migrated:
// final errorLoggerProvider = Provider<ErrorLogger>((ref) {
//   return ErrorLogger();
// });
final errorLoggerProvider = RiveBlocProvider.finalValue(
  ErrorLogger.new,
  keepAlive: true,
);
