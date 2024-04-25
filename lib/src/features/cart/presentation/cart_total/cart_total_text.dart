import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Text widget for showing the total price of the cart
class CartTotalText extends RiveBlocWidget {
  const CartTotalText({super.key});

  @override
  Widget build(context, ref) {
    final cartTotal = ref.watch(cartTotalProvider);
    final totalFormatted =
        ref.read(currencyFormatterProvider).format(cartTotal);
    return Text(
      'Total: $totalFormatted',
      style: Theme.of(context).textTheme.headlineSmall,
      textAlign: TextAlign.center,
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CartTotalText';
  }
}
