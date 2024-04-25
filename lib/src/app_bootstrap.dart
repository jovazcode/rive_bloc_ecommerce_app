import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/presentation/add_to_cart/add_to_cart_controller.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_screen_controller.dart';
import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_button_controller.dart';
import 'package:ecommerce_app/src/features/orders/application/user_orders_provider.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/products_search_state_provider.dart';
import 'package:ecommerce_app/src/features/reviews/application/fake_reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/leave_review_screen/leave_review_controller.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:ecommerce_app/src/utils/currency_formatter.dart';
import 'package:ecommerce_app/src/utils/current_date_provider.dart';
import 'package:ecommerce_app/src/utils/date_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Migrated:
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/exceptions/error_logger.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:rive_bloc/rive_bloc.dart';

/// Helper class to initialize services and configure the error handlers
class AppBootstrap {
  /// Create the root widget that should be passed to [runApp].
  Widget createRootWidget({
    List<ProviderBase> overrides = const [],
  }) {
    return RiveBlocScope(
      overrides: overrides,
      providers: [
        errorLoggerProvider,

        currencyFormatterProvider,
        currentDateBuilderProvider,
        dateFormatterProvider,

        // navigation
        goRouterProvider,

        // authentication
        authStateChangesProvider,
        accountScreenControllerProvider,
        emailPasswordSignInControllerProvider,

        // cart
        cartProvider,
        cartItemsCountProvider,
        itemAvailableQuantityProvider,
        cartTotalProvider,
        addToCartControllerProvider,
        shoppingCartScreenControllerProvider,

        // orders
        userOrdersProvider,
        matchingUserOrdersProvider,
        itemQuantityControllerProvider,
        paymentButtonControllerProvider,

        // products
        productProvider,
        productsListStreamProvider,
        productsListFutureProvider,
        productsListSearchProvider,
        productsSearchQueryStateProvider,
        productsSearchResults,

        // reviews
        productReviewsProvider,
        userReviewFutureProvider,
        userReviewStreamProvider,
        leaveReviewControllerProvider,

        // repositories
        authRepositoryProvider,
        productsRepositoryProvider,
        reviewsRepositoryProvider,
        ordersRepositoryProvider,
        localCartRepositoryProvider,
        remoteCartRepositoryProvider,

        // services
        cartServiceProvider,
        cartSyncServiceProvider,
        checkoutServiceProvider,
        reviewsServiceProvider
      ],
      runScoped: (context, ref) {
        // * Initialize CartSyncService to start the listener
        ref.read(cartSyncServiceProvider);

        // * Register error handlers. For more info, see:
        // * https://docs.flutter.dev/testing/errors
        // final errorLogger = container.read(errorLoggerProvider);
        final errorLogger = errorLoggerProvider.value;
        registerErrorHandlers(errorLogger);
      },
      child: const MyApp(),
    );
  }

  // Register Flutter error handlers
  void registerErrorHandlers(ErrorLogger errorLogger) {
    // * Show some error UI if any uncaught exception happens
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      errorLogger.logError(details.exception, details.stack);
    };
    // * Handle errors from the underlying platform/OS
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      errorLogger.logError(error, stack);
      return true;
    };
    // * Show some error UI when any widget in the app fails to build
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('An error occurred'.hardcoded),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }
}
