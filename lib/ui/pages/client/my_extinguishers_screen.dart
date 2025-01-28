import 'package:firetrack360/models/product.dart';
import 'package:firetrack360/models/user_role.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/ui/pages/widgets/empty_screen.dart';
import 'package:firetrack360/ui/pages/widgets/error_screen.dart';
import 'package:firetrack360/ui/pages/widgets/loading_screen.dart';
import 'package:firetrack360/ui/pages/widgets/product_list.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
class MyExtinguishersScreen extends StatelessWidget {
  const MyExtinguishersScreen({super.key});

  bool get canManageProducts {
  final role = AuthService.getRole();
  return role == UserRole.ADMIN || role == UserRole.MANAGER;
}


  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql('''
          query GetAllProducts {
            getAllProducts {
              id
              name
              serialNumber
              type
              size
              description
              price
              stockQuantity
              imageUrl
            }
          }
        '''),
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if (result.hasException) {
          return ErrorScreen(
            title: 'Extinguishers',
            error: result.exception.toString(),
            onRetry: () => refetch?.call(),
          );
        }

        if (result.isLoading) {
          return const LoadingScreen(title: 'My Extinguishers');
        }

        final List<Product> products = (result.data?['getAllProducts'] as List<dynamic>?)
            ?.map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList() ?? [];

        if (products.isEmpty) {
          return EmptyScreen(
            title: 'My Extinguishers',
            message: 'No extinguishers found',
            icon: Icons.fire_extinguisher,
            showAddButton: canManageProducts,
            onAddPressed: () => _navigateToAddProduct(context),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Extinguishers'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => refetch?.call(),
              ),
              if (canManageProducts)
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _navigateToAddProduct(context),
                ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async => await refetch?.call(),
            child: ProductList(
              products: products,
              canManageProducts: canManageProducts,
            ),
          ),
        );
      },
    );
  }

  void _navigateToAddProduct(BuildContext context) {
    Navigator.pushNamed(context, '/add-extinguisher');
  }
}
