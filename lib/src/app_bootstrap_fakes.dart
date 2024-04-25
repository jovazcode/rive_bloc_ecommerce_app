import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/reviews/application/fake_reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
// Migrated:
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_app/src/features/cart/data/local/fake_local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:rive_bloc/rive_bloc.dart';

/// Creates the top-level [ProviderContainer] by overriding providers with fake
/// repositories only. This is useful for testing purposes and for running the
/// app with a "fake" backend.
///
/// Note: all repositories needed by the app can be accessed via providers.
/// Some of these providers throw an [UnimplementedError] by default.
///
/// Example:
/// ```dart
/// @Riverpod(keepAlive: true)
/// LocalCartRepository localCartRepository(LocalCartRepositoryRef ref) {
///   throw UnimplementedError();
/// }
/// ```
///
/// As a result, this method does two things:
/// - create and configure the repositories as desired
/// - override the default implementations with a list of "overrides"
Future<List<ProviderBase>> createFakeProvidersList(
    {bool addDelay = true}) async {
  final authRepository = FakeAuthRepository(addDelay: addDelay);
  final productsRepository = FakeProductsRepository(addDelay: addDelay);
  final reviewsRepository = FakeReviewsRepository(addDelay: addDelay);
  // * set delay to false to make it easier to add/remove items
  final localCartRepository = FakeLocalCartRepository(addDelay: false);
  final remoteCartRepository = FakeRemoteCartRepository(addDelay: false);
  final ordersRepository = FakeOrdersRepository(addDelay: addDelay);

  // services
  final checkoutService = FakeCheckoutService(
    authRepository: authRepository,
    remoteCartRepository: remoteCartRepository,
    fakeOrdersRepository: ordersRepository,
    fakeProducsRepository: productsRepository,
    currentDateBuilder: () => DateTime.now(),
  );
  final reviewsService = FakeReviewsService(
    fakeProductsRepository: productsRepository,
    authRepository: authRepository,
    reviewsRepository: reviewsRepository,
  );

  return [
    // repositories
    authRepositoryProvider.overrideWithValue(authRepository),
    productsRepositoryProvider.overrideWithValue(productsRepository),
    reviewsRepositoryProvider.overrideWithValue(reviewsRepository),
    ordersRepositoryProvider.overrideWithValue(ordersRepository),
    localCartRepositoryProvider.overrideWithValue(localCartRepository),
    remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
    // services
    checkoutServiceProvider.overrideWithValue(ValueCubit(checkoutService)),
    reviewsServiceProvider.overrideWithValue(reviewsService),
  ];
}
