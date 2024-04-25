import 'dart:async';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// Migrated:
// @riverpod
// class AccountScreenController extends _$AccountScreenController {
//   @override
//   FutureOr<void> build() {
//     // nothing to do
//   }
//   Future<void> signOut() async {
//     final authRepository = ref.read(authRepositoryProvider);
//     state = const AsyncLoading();
//     state = await AsyncValue.guard(() => authRepository.signOut());
//   }
// }
final accountScreenControllerProvider =
    RiveBlocProvider.async(AccountScreenControllerCubit.new);

class AccountScreenControllerCubit extends AsyncCubit<void> {
  AccountScreenControllerCubit()
      : super((ref, args) => const AsyncValue.data(null));

  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryProvider);
    emit(const AsyncLoading());
    emit(await AsyncValue.guard(() => authRepository.signOut()));
  }
}
