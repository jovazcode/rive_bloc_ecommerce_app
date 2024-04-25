import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_screen.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/checkout_screen/checkout_screen.dart';
import 'package:ecommerce_app/src/features/orders/presentation/orders_list/orders_list_screen.dart';
import 'package:ecommerce_app/src/features/products/presentation/product_screen/product_screen.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/products_list_screen.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/leave_review_screen/leave_review_screen.dart';
import 'package:ecommerce_app/src/routing/go_router_refresh_stream.dart';
import 'package:ecommerce_app/src/routing/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:riverpod_annotation/riverpod_annotation.dart';

/// All the supported routes in the app.
/// By using an enum, we route by name using this syntax:
/// ```dart
/// context.goNamed(AppRoute.orders.name)
/// ```
enum AppRoute {
  home,
  product,
  leaveReview,
  cart,
  checkout,
  orders,
  account,
  signIn,
}

/// returns the GoRouter instance that defines all the routes in the app
final goRouterProvider = RiveBlocProvider.value<ValueCubit<GoRouter>, GoRouter>(
    () => ValueCubit(GoRouter(routes: []), build: (ref, args) {
          final authRepository = ref.read(authRepositoryProvider);
          return GoRouter(
            initialLocation: '/',
            debugLogDiagnostics: true,
            // * redirect logic based on the authentication state
            redirect: (context, state) async {
              final user = authRepository.currentUser;
              final isLoggedIn = user != null;
              final path = state.uri.path;
              if (isLoggedIn) {
                if (path == '/signIn') {
                  return '/';
                }
              } else {
                if (path == '/account' || path == '/orders') {
                  return '/';
                }
              }
              return null;
            },
            refreshListenable:
                GoRouterRefreshStream(authRepository.authStateChanges()),
            routes: [
              GoRoute(
                path: '/',
                name: AppRoute.home.name,
                builder: (context, state) => const ProductsListScreen(),
                routes: [
                  GoRoute(
                    path: 'product/:id',
                    name: AppRoute.product.name,
                    builder: (context, state) {
                      final productId = state.pathParameters['id']!;
                      return ProductScreen(productId: productId);
                    },
                    routes: [
                      GoRoute(
                        path: 'review',
                        name: AppRoute.leaveReview.name,
                        pageBuilder: (context, state) {
                          final productId = state.pathParameters['id']!;
                          return MaterialPage(
                            fullscreenDialog: true,
                            child: LeaveReviewScreen(productId: productId),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'cart',
                    name: AppRoute.cart.name,
                    pageBuilder: (context, state) => const MaterialPage(
                      fullscreenDialog: true,
                      child: ShoppingCartScreen(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'checkout',
                        name: AppRoute.checkout.name,
                        pageBuilder: (context, state) => const MaterialPage(
                          fullscreenDialog: true,
                          child: CheckoutScreen(),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'orders',
                    name: AppRoute.orders.name,
                    pageBuilder: (context, state) => const MaterialPage(
                      fullscreenDialog: true,
                      child: OrdersListScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'account',
                    name: AppRoute.account.name,
                    pageBuilder: (context, state) => const MaterialPage(
                      fullscreenDialog: true,
                      child: AccountScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'signIn',
                    name: AppRoute.signIn.name,
                    pageBuilder: (context, state) => const MaterialPage(
                      fullscreenDialog: true,
                      child: EmailPasswordSignInScreen(
                        formType: EmailPasswordSignInFormType.signIn,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            errorBuilder: (context, state) => const NotFoundScreen(),
          );
        }));