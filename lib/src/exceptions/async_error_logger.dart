import 'package:ecommerce_app/src/exceptions/app_exception.dart';
import 'package:ecommerce_app/src/exceptions/error_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Error logger class to keep track of all AsyncError states that are set
/// by the controllers in the app
// Migrated:
// class AsyncErrorLogger extends ProviderObserver {
class AsyncErrorLogger extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    //print('<CREATE> $bloc');
    super.onCreate(bloc);
  }

  @override
  void onChange(
    BlocBase bloc,
    Change change,
  ) {
    //print('<CHANGE> [${bloc.runtimeType}] $change');
    super.onChange(bloc, change);
    // Migrated:
    // final errorLogger = container.read(errorLoggerProvider);
    final errorLogger = errorLoggerProvider.value;
    final error = _findError(change.nextState);
    if (error != null) {
      if (error.error is AppException) {
        // only prints the AppException data
        errorLogger.logAppException(error.error as AppException);
      } else {
        // prints everything including the stack trace
        errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  AsyncError<dynamic>? _findError(Object? value) {
    if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
