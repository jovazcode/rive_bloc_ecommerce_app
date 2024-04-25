import 'package:ecommerce_app/src/app.dart';
// import 'package:ecommerce_app/src/app_bootstrap_fakes.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
// Migrated:
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive_bloc/rive_bloc.dart';
import 'features/authentication/auth_robot.dart';
import 'features/cart/cart_robot.dart';
import 'features/checkout/checkout_robot.dart';
import 'features/orders/orders_robot.dart';
import 'features/products/products_robot.dart';
import 'features/reviews/reviews_robot.dart';
import 'goldens/golden_robot.dart';

class Robot {
  Robot(this.tester)
      : auth = AuthRobot(tester),
        products = ProductsRobot(tester),
        cart = CartRobot(tester),
        checkout = CheckoutRobot(tester),
        orders = OrdersRobot(tester),
        reviews = ReviewsRobot(tester),
        golden = GoldenRobot(tester);
  final WidgetTester tester;
  final AuthRobot auth;
  final ProductsRobot products;
  final CartRobot cart;
  final CheckoutRobot checkout;
  final OrdersRobot orders;
  final ReviewsRobot reviews;
  final GoldenRobot golden;

  Future<void> pumpMyAppWithFakes() async {
    final container = await createFakesProviderContainer(addDelay: false);
    // * Initialize CartSyncService to start the listener
    container.read(cartSyncServiceProvider);
    // * Entry point of the app
    await tester.pumpWidget(
      // Migrated:
      // UncontrolledProviderScope(
      //   container: container,
      //   child: const MyApp(),
      // ),
      const RiveBlocScope(
        child: MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openPopupMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matches = finder.evaluate();
    // if an item is found, it means that we're running
    // on a small window and can tap to reveal the menu
    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }

  // navigation
  Future<void> closePage() async {
    final finder = find.byTooltip('Close');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> goBack() async {
    final finder = find.byTooltip('Back');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> fullPurchaseFlow() async {
    products.expectProductsListLoaded();
    // add to cart flows
    await products.selectProduct();
    await products.setProductQuantity(3);
    await cart.addToCart();
    await cart.openCart();
    cart.expectFindNCartItems(1);
    // checkout
    await checkout.startCheckout();
    await auth.enterAndSubmitEmailAndPassword();
    cart.expectFindNCartItems(1);
    await checkout.startPayment();
    // when a payment is complete, user is taken to the orders page
    orders.expectFindNOrders(1);
    await closePage(); // close orders page
    // check that cart is now empty
    await cart.openCart();
    cart.expectFindZeroCartItems();
    await closePage();
    // reviews flow
    await products.selectProduct();
    reviews.expectFindLeaveReview();
    await reviews.tapLeaveReviewButton();
    await reviews.createAndSubmitReview('Love it!');
    reviews.expectFindOneReview();
    // sign out
    await openPopupMenu();
    await auth.openAccountScreen();
    await auth.tapLogoutButton();
    await auth.tapDialogLogoutButton();
    products.expectProductsListLoaded();
  }
}
