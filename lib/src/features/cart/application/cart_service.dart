import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

class CartService {
  // Migrated:
  // CartService(this.ref);
  // final RiveBlocRef ref;

  // FakeAuthRepository get authRepository => ref.read(authRepositoryProvider);
  // FakeRemoteCartRepository get remoteCartRepository =>
  //     ref.read(remoteCartRepositoryProvider);
  // LocalCartRepository get localCartRepository =>
  //     ref.read(localCartRepositoryProvider);

  CartService();

  FakeAuthRepository get authRepository => authRepositoryProvider.value;
  FakeRemoteCartRepository get remoteCartRepository =>
      remoteCartRepositoryProvider.value;
  LocalCartRepository get localCartRepository =>
      localCartRepositoryProvider.value;

  /// fetch the cart from the local or remote repository
  /// depending on the user auth state
  Future<Cart> _fetchCart() {
    final user = authRepository.currentUser;
    if (user != null) {
      return remoteCartRepository.fetchCart(user.uid);
    } else {
      return localCartRepository.fetchCart();
    }
  }

  /// save the cart to the local or remote repository
  /// depending on the user auth state
  Future<void> _setCart(Cart cart) async {
    final user = authRepository.currentUser;
    if (user != null) {
      await remoteCartRepository.setCart(user.uid, cart);
    } else {
      await localCartRepository.setCart(cart);
    }
  }

  /// sets an item in the local or remote cart depending on the user auth state
  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.setItem(item);
    await _setCart(updated);
  }

  /// adds an item in the local or remote cart depending on the user auth state
  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.addItem(item);
    await _setCart(updated);
  }

  /// removes an item from the local or remote cart depending on the user auth
  /// state
  Future<void> removeItemById(ProductID productId) async {
    final cart = await _fetchCart();
    final updated = cart.removeItemById(productId);
    await _setCart(updated);
  }
}

// Migrated:
// @riverpod
// CartService cartService(CartServiceRef ref) {
//   return CartService(ref);
// }
// final cartServiceProvider =
//     RiveBlocProvider.async(() => AsyncCubit((ref, args) => CartService(ref)));
final cartServiceProvider = RiveBlocProvider.finalValue(CartService.new);

// Migrated:
// @riverpod
// Stream<Cart> cart(CartRef ref) {
//   final user = ref.watch(authStateChangesProvider).value;
//   if (user != null) {
//     return ref.watch(remoteCartRepositoryProvider).watchCart(user.uid);
//   } else {
//     return ref.watch(localCartRepositoryProvider).watchCart();
//   }
// }
final cartProvider = RiveBlocProvider.stream(() => StreamBloc((ref, args) {
      final user = ref.watch(authStateChangesProvider).state.value;
      if (user != null) {
        return ref.read(remoteCartRepositoryProvider).watchCart(user.uid);
      } else {
        return ref.read(localCartRepositoryProvider).watchCart();
      }
    }));

// Migrated:
// @riverpod
// int cartItemsCount(CartItemsCountRef ref) {
//   return ref.watch(cartProvider).maybeMap(
//         data: (cart) => cart.value.items.length,
//         orElse: () => 0,
//       );
// }
final cartItemsCountProvider =
    RiveBlocProvider.value<CartItemsCountCubit, int>(CartItemsCountCubit.new);

class CartItemsCountCubit extends ValueCubit<int> {
  CartItemsCountCubit()
      : super(0, build: (ref, args) {
          final cart = ref.watch(cartProvider).state;
          return cart.maybeMap(
            data: (cart) => cart.value.items.length,
            orElse: () => 0,
          );
        });
}

// Migrated:
// @riverpod
// double cartTotal(CartTotalRef ref) {
//   final cart = ref.watch(cartProvider).value ?? const Cart();
//   final productsList = ref.watch(productsListStreamProvider).value ?? [];
//   if (cart.items.isNotEmpty && productsList.isNotEmpty) {
//     var total = 0.0;
//     for (final item in cart.items.entries) {
//       final product =
//           productsList.firstWhere((product) => product.id == item.key);
//       total += product.price * item.value;
//     }
//     return total;
//   } else {
//     return 0.0;
//   }
// }
final cartTotalProvider = RiveBlocProvider.value<CartTotalValueCubit, double>(
    CartTotalValueCubit.new);

class CartTotalValueCubit extends ValueCubit<double> {
  CartTotalValueCubit()
      : super(0.0, build: (ref, args) {
          final cart = ref.watch(cartProvider).state.value ?? const Cart();
          final productsList =
              ref.watch(productsListStreamProvider).state.value ?? [];
          if (cart.items.isNotEmpty && productsList.isNotEmpty) {
            var total = 0.0;
            for (final item in cart.items.entries) {
              final product =
                  productsList.firstWhere((product) => product.id == item.key);
              total += product.price * item.value;
            }
            return total;
          } else {
            return 0.0;
          }
        });
}

// Migrated:
// @riverpod
// int itemAvailableQuantity(ItemAvailableQuantityRef ref, Product product) {
//   final cart = ref.watch(cartProvider).value;
//   if (cart != null) {
//     // get the current quantity for the given product in the cart
//     final quantity = cart.items[product.id] ?? 0;
//     // subtract it from the product available quantity
//     return max(0, product.availableQuantity - quantity);
//   } else {
//     return product.availableQuantity;
//   }
// }
final itemAvailableQuantityProvider =
    RiveBlocProvider.value<ItemAvailableQuantityValueCubit, int>(
        ItemAvailableQuantityValueCubit.new);

class ItemAvailableQuantityValueCubit extends ValueCubit<int> {
  ItemAvailableQuantityValueCubit()
      : super(0, build: (ref, args) {
          final product = args.get<Product?>('product', null);
          assert(product != null, 'Product must not be null');
          final cart = ref.watch(cartProvider).state.value;
          if (cart != null) {
            // get the current quantity for the given product in the cart
            final quantity = cart.items[product!.id] ?? 0;
            // subtract it from the product available quantity
            return max(0, product.availableQuantity - quantity);
          } else {
            return product!.availableQuantity;
          }
        });
}
