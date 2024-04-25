import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:rive_bloc/rive_bloc.dart';
// Migrated:
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// Migrated:
// * Riverpod generator doesn't support StateProvider so we use the old syntax
// final productsSearchQueryStateProvider = StateProvider<String>((ref) {
//   return '';
// });
final productsSearchQueryStateProvider =
    RiveBlocProvider.state(() => ValueCubit(''));

// Migrated:
// @riverpod
// Future<List<Product>> productsSearchResults(ProductsSearchResultsRef ref) {
//   final searchQuery = ref.watch(productsSearchQueryStateProvider);
//   return ref.watch(productsListSearchProvider(searchQuery).future);
// }
final productsSearchResults =
    RiveBlocProvider.async(ProductSearchResultsCubit.new);

class ProductSearchResultsCubit extends AsyncCubit<List<Product>> {
  ProductSearchResultsCubit()
      : super((ref, args) {
          final searchQuery = ref.watch(productsSearchQueryStateProvider);
          return ref.watch(
            productsListSearchProvider(
              ref,
              Args({'query': searchQuery}),
            ),
          );
        });
}
