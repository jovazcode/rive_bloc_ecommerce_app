import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:rive_bloc/rive_bloc.dart';
import 'package:rxdart/rxdart.dart';
// Migrated:
// import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Watch the list of user orders
/// NOTE: Only watch this provider if the user is signed in.
// Migrated:
// @riverpod
// Stream<List<Order>> userOrders(UserOrdersRef ref) {
//   final user = ref.watch(authStateChangesProvider).value;
//   if (user != null) {
//     return ref.watch(ordersRepositoryProvider).watchUserOrders(user.uid);
//   } else {
//     // If the user is null, return an empty list (no orders)
//     return Stream.value([]);
//   }
// }
final userOrdersProvider = RiveBlocProvider.stream(UserOrdersStreamBloc.new);

class UserOrdersStreamBloc extends StreamBloc<List<Order>> {
  UserOrdersStreamBloc()
      : super((ref, args) {
          final user = ref.watch(authStateChangesProvider).state.value;
          if (user != null) {
            return ref.read(ordersRepositoryProvider).watchUserOrders(user.uid);
          } else {
            // If the user is null, return an empty list (no orders)
            return BehaviorSubject<List<Order>>.seeded([]).stream;
            // return Stream.value([]);
          }
        });
}

/// Check if a product was previously purchased by the user
// Migrated:
// @riverpod
// Stream<List<Order>> matchingUserOrders(
//     MatchingUserOrdersRef ref, ProductID productId) {
//   final user = ref.watch(authStateChangesProvider).value;
//   if (user != null) {
//     return ref
//         .watch(ordersRepositoryProvider)
//         .watchUserOrders(user.uid, productId: productId);
//   } else {
//     // If the user is null, return an empty list (no orders)
//     return Stream.value([]);
//   }
// }

final matchingUserOrdersProvider =
    RiveBlocProvider.stream<MatchingUserOrdersStreamBloc, List<Order>>(
        MatchingUserOrdersStreamBloc.new);

class MatchingUserOrdersStreamBloc extends StreamBloc<List<Order>> {
  MatchingUserOrdersStreamBloc()
      : super((ref, args) {
          final productId = args.get<ProductID?>('id', null);
          assert(productId != null, 'ProductID must not be null');
          final user = ref.watch(authStateChangesProvider).state.value;
          if (user != null) {
            return ref
                .read(ordersRepositoryProvider)
                .watchUserOrders(user.uid, productId: productId);
          } else {
            // If the user is null, return an empty list (no orders)
            return Stream.value([]);
          }
        });
}
