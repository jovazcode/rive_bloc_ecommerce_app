import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_button_controller.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Button used to initiate the payment flow.
class PaymentButton extends RiveBlocWidget {
  const PaymentButton({super.key});

  Future<void> _pay(BuildContext context, RiveBlocRef ref) async {
    ref.read(paymentButtonControllerProvider).pay();
  }

  @override
  Widget build(context, ref) {
    ref.listen(
      paymentButtonControllerProvider,
      (_, __, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(paymentButtonControllerProvider).state;
    return PrimaryButton(
      text: 'Pay'.hardcoded,
      isLoading: state.isLoading,
      onPressed: state.isLoading ? null : () => _pay(context, ref),
    );
  }
}
