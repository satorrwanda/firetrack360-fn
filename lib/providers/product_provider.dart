// Importing necessary packages and files
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firetrack360/models/product.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firetrack360/configs/graphql_client.dart';
import 'package:firetrack360/graphql/mutations/product_mutation.dart';
import 'package:firetrack360/graphql/queries/product_query.dart';

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Pagination providers
final currentPageProvider = StateProvider<int>((ref) => 1);
final itemsPerPageProvider = StateProvider<int>((ref) => 10);

// Filtered products provider
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsyncValue = ref.watch(productNotifierProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return productsAsyncValue.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
    data: (products) {
      if (searchQuery.isEmpty) return AsyncValue.data(products);

      final filtered = products.where((product) {
        return product.name.toLowerCase().contains(searchQuery) ||
            product.description.toLowerCase().contains(searchQuery) ||
            product.serialNumber.toLowerCase().contains(searchQuery) ||
            product.type.toLowerCase().contains(searchQuery);
      }).toList();

      return AsyncValue.data(filtered);
    },
  );
});

// Paginated products provider
final paginatedProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final filteredProductsAsync = ref.watch(filteredProductsProvider);
  final currentPage = ref.watch(currentPageProvider);
  final itemsPerPage = ref.watch(itemsPerPageProvider);

  return filteredProductsAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
    data: (filteredProducts) {
      final startIndex = (currentPage - 1) * itemsPerPage;
      final endIndex = startIndex + itemsPerPage;

      if (startIndex >= filteredProducts.length) {
        // If we're past the end, return empty list
        return const AsyncValue.data([]);
      }

      return AsyncValue.data(filteredProducts.sublist(
        startIndex,
        endIndex > filteredProducts.length ? filteredProducts.length : endIndex,
      ));
    },
  );
});

// Total pages provider
final totalPagesProvider = Provider<int>((ref) {
  final filteredProducts = ref.watch(filteredProductsProvider);
  final itemsPerPage = ref.watch(itemsPerPageProvider);

  return filteredProducts.when(
    loading: () => 1,
    error: (_, __) => 1,
    data: (products) => (products.length / itemsPerPage).ceil(),
  );
});

// Product notifier provider
final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductNotifier();
});

// Product notifier class
class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductNotifier() : super(const AsyncValue.loading()) {
    fetchAllProducts();
  }

  // Method to create a new product
  Future<void> createProduct(Map<String, dynamic> productInput) async {
    try {
      final client = GraphQLConfiguration.initializeClient().value;
      final result = await client.mutate(MutationOptions(
        document: gql(createProductMutation),
        variables: {'productInput': productInput},
      ));

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      await fetchAllProducts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Method to fetch all products
  Future<void> fetchAllProducts() async {
    state = const AsyncValue.loading();
    try {
      final client = GraphQLConfiguration.initializeClient().value;
      final result = await client.query(QueryOptions(
        document: gql(getAllProductsQuery),
        fetchPolicy: FetchPolicy.networkOnly,
      ));

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      if (result.data == null) {
        throw Exception('No data returned from GraphQL query');
      }

      final productsData = result.data!['getAllProducts'] as List<dynamic>?;

      if (productsData == null) {
        state = const AsyncValue.data([]);
        return;
      }

      final products = productsData
          .where((item) => item != null)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      state = AsyncValue.data(products);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Method to delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      final client = GraphQLConfiguration.initializeClient().value;
      final result = await client.mutate(
        MutationOptions(
          document: gql(deleteProductMutation),
          variables: {
            'productId': productId,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      await fetchAllProducts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  // Method to update a product
  Future<void> updateProduct(
      String id, Map<String, dynamic> productInput) async {
    try {
      final client = GraphQLConfiguration.initializeClient().value;
      final result = await client.mutate(
        MutationOptions(
          document: gql(updateProductMutation),
          variables: {
            'id': id,
            'productInput': productInput,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      await fetchAllProducts();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}
