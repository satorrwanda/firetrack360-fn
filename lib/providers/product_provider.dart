import 'package:firetrack360/graphql/mutations/product_mutation.dart';
import 'package:firetrack360/graphql/queries/product_query.dart';
import 'package:firetrack360/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firetrack360/configs/graphql_client.dart';

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

      print('Query result: ${result.data}'); // Add this to see the raw response

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final productsData = result.data?['getAllProducts'] as List;
      if (productsData == null) {
        throw Exception('Failed to fetch products');
      }

      final products = productsData.map((e) => Product.fromJson(e)).toList();
      print('Successfully loaded ${products.length} products');
      state = AsyncValue.data(products);
    } catch (error, stackTrace) {
      print('Error fetching products: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final productNotifierProvider =
    StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>(
        (ref) => ProductNotifier());
