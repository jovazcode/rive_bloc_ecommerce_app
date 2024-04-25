// Migrated:
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rive_bloc/rive_bloc.dart';

// Migrated:
// final dateFormatterProvider = Provider<DateFormat>((ref) {
//   /// Date formatter to be used in the app.
//   return DateFormat.MMMEd();
// });
final dateFormatterProvider = RiveBlocProvider.finalValue(() {
  /// Date formatter to be used in the app.
  return DateFormat.MMMEd();
});
