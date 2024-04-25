import 'dart:async';

import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/utils/notifier_mounted.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// Migrated:
// @riverpod
// class PaymentButtonController extends _$PaymentButtonController
//     with NotifierMounted {
//   @override
//   FutureOr<void> build() {
//     ref.onDispose(setUnmounted);
//     // nothing to do
//   }

//   Future<void> pay() async {
//     final checkoutService = ref.read(checkoutServiceProvider);
//     state = const AsyncLoading();
//     final newState = await AsyncValue.guard(checkoutService.placeOrder);
//     // * Check if the controller is mounted before setting the state to prevent:
//     // * Bad state: Tried to use PaymentButtonController after `dispose` was called.
//     if (mounted) {
//       state = newState;
//     }
//   }
// }
final paymentButtonControllerProvider =
    RiveBlocProvider.async(PaymentButtonValueCubit.new);

class PaymentButtonValueCubit extends AsyncCubit<void> with NotifierMounted {
  PaymentButtonValueCubit() : super((ref, args) => const AsyncValue.data(null));

  Future<void> pay() async {
    emit(const AsyncLoading());
    emit(await AsyncValue.guard<void>(
      ref.read(checkoutServiceProvider)!.placeOrder,
    ));
  }
}
