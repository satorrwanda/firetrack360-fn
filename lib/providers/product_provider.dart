// lib/providers/product_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firetrack360/models/product.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firetrack360/configs/graphql_client.dart';
import 'package:firetrack360/graphql/mutations/product_mutation.dart';
import 'package:firetrack360/graphql/queries/product_query.dart';




final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  return ProductNotifier();
});

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductNotifier() : super(const AsyncValue.loading()) {
    fetchAllProducts();
  }

  Future<void> createProduct(Map<String, dynamic> productInput) async {
    state = const AsyncValue.loading();
    try {
      final client = GraphQLConfiguration.initializeClient().value;
      final result = await client.mutate(MutationOptions(
        document: gql(createProductMutation),
        variables: {'productInput': productInput},
      ));

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      await fetchAllProducts(); // Refresh the product list after creation
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> fetchAllProducts() async {
    print('Starting to fetch products');
    try {
      final client = GraphQLConfiguration.initializeClient().value;
      final result = await client.query(QueryOptions(
        document: gql(getAllProductsQuery),
      ));

      print('Raw GraphQL response: ${result.data}');

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      if (result.data == null) {
        throw Exception('No data returned from GraphQL query');
      }

      final productsData = result.data!['getAllProducts'] as List<dynamic>?;

      if (productsData == null) {
        print('No products data in response');
        state = const AsyncValue.data([]);
        return;
      }

      final products = productsData
          .where((item) => item != null)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      print('Successfully loaded ${products.length} products');
      state = AsyncValue.data(products);
    } catch (error, stackTrace) {
      print('Error fetching products: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
