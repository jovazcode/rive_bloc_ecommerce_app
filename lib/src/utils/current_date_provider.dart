// Migrated:
// import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rive_bloc/rive_bloc.dart';

/// A provider that returns a function that returns the current date.
/// This makes it easy to mock the current date in tests.
final currentDateBuilderProvider = RiveBlocProvider.finalValue(() {
  return () => DateTime.now();
});
