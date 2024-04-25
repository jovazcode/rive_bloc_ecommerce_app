import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:riverpod_annotation/riverpod_annotation.dart';

/// API for reading, watching and writing local cart data (guest user)
abstract class LocalCartRepository {
  Future<Cart> fetchCart();

  Stream<Cart> watchCart();

  Future<void> setCart(Cart cart);
}

// Migrated:
// @Riverpod(keepAlive: true)
// LocalCartRepository localCartRepository(LocalCartRepositoryRef ref) {
//   throw UnimplementedError();
// }
final localCartRepositoryProvider =
    RiveBlocProvider.finalValue<LocalCartRepository>(
  () => throw UnimplementedError(),
);
