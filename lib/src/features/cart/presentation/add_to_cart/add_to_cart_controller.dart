import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// Migrated:
// @riverpod
// class AddToCartController extends _$AddToCartController {
//   @override
//   FutureOr<void> build() {
//     // nothing to do
//   }

//   Future<void> addItem(ProductID productId) async {
//     final cartService = ref.read(cartServiceProvider);
//     final quantity = ref.read(itemQuantityControllerProvider);
//     final item = Item(productId: productId, quantity: quantity);
//     state = const AsyncLoading<void>();
//     state = await AsyncValue.guard(() => cartService.addItem(item));
//     if (!state.hasError) {
//       ref.read(itemQuantityControllerProvider.notifier).updateQuantity(1);
//     }
//   }
// }
final addToCartControllerProvider =
    RiveBlocProvider.async(AddToCartControllerCubit.new);

class AddToCartControllerCubit extends AsyncCubit<void> {
  AddToCartControllerCubit()
      : super((ref, args) => const AsyncValue.data(null));

  Future<void> addItem(ProductID productId) async {
    final cartService = ref.read(cartServiceProvider);
    final quantity = ref.read(itemQuantityControllerProvider).state;
    final item = Item(productId: productId, quantity: quantity);
    emit(const AsyncLoading<void>());
    emit(await AsyncValue.guard(() => cartService.addItem(item)));
    if (!state.hasError) {
      ref.read(itemQuantityControllerProvider).updateQuantity(1);
    }
  }
}

// Migrated:
// @riverpod
// class ItemQuantityController extends _$ItemQuantityController {
//   @override
//   int build() {
//     return 1;
//   }

//   void updateQuantity(int quantity) {
//     state = quantity;
//   }
// }
final itemQuantityControllerProvider =
    RiveBlocProvider.state(ItemQuantityControllerCubit.new);

class ItemQuantityControllerCubit extends ValueCubit<int> {
  ItemQuantityControllerCubit() : super(1);

  void updateQuantity(int quantity) {
    state = quantity;
  }
}
