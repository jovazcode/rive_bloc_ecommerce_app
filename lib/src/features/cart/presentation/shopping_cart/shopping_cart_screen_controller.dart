import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// Migrated:
// @riverpod
// class ShoppingCartScreenController extends _$ShoppingCartScreenController {
//   @override
//   FutureOr<void> build() {
//     // nothing to do
//   }

//   CartService get _cartService => ref.read(cartServiceProvider);

//   Future<void> updateItemQuantity(ProductID productId, int quantity) async {
//     state = const AsyncLoading();
//     final updated = Item(productId: productId, quantity: quantity);
//     state = await AsyncValue.guard(() => _cartService.setItem(updated));
//   }

//   Future<void> removeItemById(ProductID productId) async {
//     state = const AsyncLoading();
//     state =
//         await AsyncValue.guard(() => _cartService.removeItemById(productId));
//   }
// }
final shoppingCartScreenControllerProvider =
    RiveBlocProvider.async(ShoppingCartScreenController.new);

class ShoppingCartScreenController extends AsyncCubit<void> {
  ShoppingCartScreenController()
      : super((ref, args) => const AsyncValue.data(null));

  CartService get _cartService => ref.read(cartServiceProvider);

  Future<void> updateItemQuantity(ProductID productId, int quantity) async {
    emit(const AsyncValue.loading());
    final updated = Item(productId: productId, quantity: quantity);
    emit(await AsyncValue.guard(() => _cartService.setItem(updated)));
  }

  Future<void> removeItemById(ProductID productId) async {
    emit(const AsyncValue.loading());
    emit(await AsyncValue.guard(() => _cartService.removeItemById(productId)));
  }
}
