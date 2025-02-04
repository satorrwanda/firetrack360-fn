// lib/ui/screens/inventory_screen.dart

import 'package:firetrack360/models/product.dart';
import 'package:firetrack360/ui/pages/widgets/product_card.dart';
import 'package:firetrack360/ui/widgets/create_product_dialog.dart';
import 'package:firetrack360/ui/widgets/edit_product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firetrack360/providers/product_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  void _showCreateProductDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => CreateProductDialog(
        uploadEndpoint: dotenv.env['FILE_UPLOAD_ENDPOINT']!,
        onSubmit: (productData) async {
          try {
            await ref
                .read(productNotifierProvider.notifier)
                .createProduct(productData);

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product created successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
              // Refresh data after creating
              _refreshData(context, ref);
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error creating product: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref
                    .read(productNotifierProvider.notifier)
                    .deleteProduct(product.id);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                  // Refresh data after deleting
                  _refreshData(context, ref);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting product: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Product product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditProductDialog(
        product: product,
        onSubmit: (id, productData) async {
          try {
            await ref.read(productNotifierProvider.notifier).updateProduct(
                  id,
                  productData,
                );

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
              await _refreshData(context, ref);
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error updating product: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _refreshData(BuildContext context, WidgetRef ref) async {
    try {
      ref.read(currentPageProvider.notifier).state = 1;
      await ref.read(productNotifierProvider.notifier).fetchAllProducts();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inventory updated'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginatedProducts = ref.watch(paginatedProductsProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);
    final currentPage = ref.watch(currentPageProvider);
    final totalPages = ref.watch(totalPagesProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fire Extinguisher Inventory',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withRed(150),
              ],
            ),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _refreshData(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateProductDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context, ref),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                  ref.read(currentPageProvider.notifier).state = 1;
                },
                decoration: InputDecoration(
                  hintText: 'Search extinguishers...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            ref.read(searchQueryProvider.notifier).state = '';
                            ref.read(currentPageProvider.notifier).state = 1;
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            // Summary header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.fire_extinguisher, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Available Extinguishers',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  filteredProducts.when(
                    data: (items) => Text(
                      '${items.length} items',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ),

            // Product List
            Expanded(
              child: paginatedProducts.when(
                data: (products) {
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isEmpty
                                ? 'No extinguishers available'
                                : 'No extinguishers match your search',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (searchQuery.isEmpty)
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _showCreateProductDialog(context, ref),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Extinguisher'),
                            ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          // TODO: Navigate to product details
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => ProductDetailsScreen(product: product),
                          //   ),
                          // );
                        },
                        onEdit: () => _showEditDialog(context, ref, product),
                        onDelete: () =>
                            _showDeleteConfirmation(context, ref, product),
                        canManageProducts: true,
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading products',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _refreshData(context, ref),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (paginatedProducts.maybeWhen(
              data: (products) => products.isNotEmpty,
              orElse: () => false,
            ))
              // Pagination Controls
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: currentPage > 1
                          ? () => ref
                              .read(currentPageProvider.notifier)
                              .update((state) => state - 1)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Page $currentPage of $totalPages',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: currentPage < totalPages
                          ? () => ref
                              .read(currentPageProvider.notifier)
                              .update((state) => state + 1)
                          : null,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
