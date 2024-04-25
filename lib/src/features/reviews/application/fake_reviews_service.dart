import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:riverpod_annotation/riverpod_annotation.dart';

class FakeReviewsService {
  const FakeReviewsService({
    required this.fakeProductsRepository,
    required this.authRepository,
    required this.reviewsRepository,
  });
  final FakeProductsRepository fakeProductsRepository;
  final FakeAuthRepository authRepository;
  final FakeReviewsRepository reviewsRepository;

  Future<void> submitReview({
    required ProductID productId,
    required Review review,
  }) async {
    final user = authRepository.currentUser;
    // * we should only call this method when the user is signed in
    assert(user != null);
    if (user == null) {
      throw AssertionError(
          'Can\'t submit a review if the user is not signed in'.hardcoded);
    }
    await reviewsRepository.setReview(
      productId: productId,
      uid: user.uid,
      review: review,
    );
    // * Note: this should be done on the backend
    // * At this stage the review is already submitted
    // * and we don't need to await for the product rating to also be updated
    _updateProductRating(productId);
  }

  Future<void> _updateProductRating(ProductID productId) async {
    final reviews = await reviewsRepository.fetchReviews(productId);
    final avgRating = _avgReviewScore(reviews);
    final product = fakeProductsRepository.getProduct(productId);
    if (product == null) {
      throw StateError('Product not found with id: $productId.'.hardcoded);
    }
    final updated = product.copyWith(
      avgRating: avgRating,
      numRatings: reviews.length,
    );
    await fakeProductsRepository.setProduct(updated);
  }

  double _avgReviewScore(List<Review> reviews) {
    if (reviews.isNotEmpty) {
      var total = 0.0;
      for (var review in reviews) {
        total += review.rating;
      }
      return total / reviews.length;
    } else {
      return 0.0;
    }
  }
}

// Migrated:
// @riverpod
// FakeReviewsService reviewsService(ReviewsServiceRef ref) {
//   return FakeReviewsService(
//     fakeProductsRepository: ref.watch(productsRepositoryProvider),
//     authRepository: ref.watch(authRepositoryProvider),
//     reviewsRepository: ref.watch(reviewsRepositoryProvider),
//   );
// }
// final reviewsServiceProvider =
//     RiveBlocProvider.async(() => AsyncCubit((ref, args) => FakeReviewsService(
//           fakeProductsRepository: productsRepositoryProvider.value,
//           authRepository: authRepositoryProvider.value,
//           reviewsRepository: reviewsRepositoryProvider.value,
//         )));
final reviewsServiceProvider =
    RiveBlocProvider.finalValue(() => FakeReviewsService(
          fakeProductsRepository: productsRepositoryProvider.value,
          authRepository: authRepositoryProvider.value,
          reviewsRepository: reviewsRepositoryProvider.value,
        ));

// Migrated:
/// Check if a product was previously reviewed by the user
// @riverpod
// Future<Review?> userReviewFuture(UserReviewFutureRef ref, ProductID productId) {
//   final user = ref.watch(authStateChangesProvider).value;
//   if (user != null) {
//     return ref
//         .watch(reviewsRepositoryProvider)
//         .fetchUserReview(productId, user.uid);
//   } else {
//     return Future.value(null);
//   }
// }
final userReviewFutureProvider =
    RiveBlocProvider.async(UserReviewAsyncCubit.new);

class UserReviewAsyncCubit extends AsyncCubit<Review?> {
  UserReviewAsyncCubit()
      : super((ref, args) {
          final productId = args.get<ProductID?>('id', null);
          assert(
              productId != null, 'ProductID is required for productReviews.');

          final user = ref.watch(authStateChangesProvider).state.value;
          if (user != null) {
            return ref
                .read(reviewsRepositoryProvider)
                .fetchUserReview(productId!, user.uid);
          } else {
            return Future.value(null);
          }
        });
}

// Migrated:
/// Check if a product was previously reviewed by the user
// @riverpod
// Stream<Review?> userReviewStream(UserReviewStreamRef ref, ProductID productId) {
//   final user = ref.watch(authStateChangesProvider).value;
//   if (user != null) {
//     return ref
//         .watch(reviewsRepositoryProvider)
//         .watchUserReview(productId, user.uid);
//   } else {
//     return Stream.value(null);
//   }
// }
final userReviewStreamProvider =
    RiveBlocProvider.stream(UserReviewStreamBloc.new);

class UserReviewStreamBloc extends StreamBloc<Review?> {
  UserReviewStreamBloc()
      : super((ref, args) {
          final productId = args.get<ProductID?>('id', null);
          assert(
              productId != null, 'ProductID is required for productReviews.');

          final user = ref.watch(authStateChangesProvider).state.value;
          if (user != null) {
            return ref
                .read(reviewsRepositoryProvider)
                .watchUserReview(productId!, user.uid);
          } else {
            return Stream.value(null);
          }
        });
}
