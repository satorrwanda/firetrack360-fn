// lib/ui/screens/inventory_screen.dart

import 'package:firetrack360/hooks/use_auth.dart';
import 'package:firetrack360/models/product.dart';
import 'package:firetrack360/ui/pages/admin/product_details_screen.dart';
import 'package:firetrack360/ui/widgets/create_product_dialog.dart';
import 'package:firetrack360/ui/widgets/edit_product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firetrack360/providers/product_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firetrack360/generated/l10n.dart'; // Import localization

class InventoryScreen extends HookConsumerWidget {
  const InventoryScreen({super.key});

  void _showCreateProductDialog(BuildContext context, WidgetRef ref, S l10n) {
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
                SnackBar(
                  content: Text(
                      l10n.productCreatedSuccess), // Localized success message
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
              // Refresh data after creating
              _refreshData(context, ref, l10n); // Pass l10n
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.errorCreatingProduct(
                      e.toString())), // Localized error message
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
      BuildContext context, WidgetRef ref, Product product, S l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProductTitle), // Localized title
        content: Text(
            l10n.deleteProductConfirmation(product.name)), // Localized content
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancelButton), // Localized button
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref
                    .read(productNotifierProvider.notifier)
                    .deleteProduct(product.id);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n
                          .productDeletedSuccess), // Localized success message
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                  // Refresh data after deleting
                  _refreshData(context, ref, l10n); // Pass l10n
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.errorDeletingProduct(
                          e.toString())), // Localized error message
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
            child: Text(l10n.deleteButton), // Localized button
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, Product product, S l10n) {
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
                SnackBar(
                  content: Text(
                      l10n.productUpdatedSuccess), // Localized success message
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
              await _refreshData(context, ref, l10n); // Pass l10n
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.errorUpdatingProduct(
                      e.toString())), // Localized error message
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _refreshData(BuildContext context, WidgetRef ref, S l10n) async {
    try {
      ref.read(currentPageProvider.notifier).state = 1;
      await ref.read(productNotifierProvider.notifier).fetchAllProducts();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                l10n.failedToRefresh(e.toString())), // Localized error message
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
    final l10n = S.of(context)!; // Get localized strings

    // Define app theme colors to match home screen
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color backgroundColor =
        Theme.of(context).scaffoldBackgroundColor; // Use theme background color

    final authState = useAuth();
    var isAdmin = authState.userRole?.toLowerCase() == 'admin';

    return Scaffold(
      backgroundColor: backgroundColor, // Use theme background color
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.inventory_2,
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary), // Use color on primary
            SizedBox(width: 10),
            Text(
              l10n.inventoryTitle, // Localized title
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary, // Use color on primary
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: primaryColor, // Use theme primary color
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context)
                  .colorScheme
                  .onPrimary), // Use color on primary
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary), // Use color on primary
            onPressed: () {
              // Navigate to notifications screen if you have one
              // AppRoutes.navigateToNotification(context);
            },
            tooltip: l10n.notificationsTooltip, // Localized tooltip
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () =>
                  _showCreateProductDialog(context, ref, l10n), // Pass l10n
              icon: const Icon(Icons.add),
              label: Text(l10n.newButton), // Localized label
              backgroundColor: primaryColor,
              foregroundColor: Theme.of(context)
                  .colorScheme
                  .onPrimary, // Use color on primary
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context, ref, l10n), // Pass l10n
        color: primaryColor, // Use theme primary color for refresh indicator
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
                  hintText: l10n.searchExtinguishersHint, // Localized hint text
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary), // Use secondary color
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary), // Use secondary color
                          onPressed: () {
                            ref.read(searchQueryProvider.notifier).state = '';
                            ref.read(currentPageProvider.notifier).state = 1;
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor:
                      Theme.of(context).cardColor, // Use theme card color
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16), // Adjusted horizontal padding
                ),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium, // Use theme text style
              ),
            ),

            // Summary header
            // Summary header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor, // Use theme card color
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .shadowColor
                        .withOpacity(0.05), // Use theme shadow color
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Wrap the text and icon in an Expanded or Flexible to prevent overflow
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Allow this inner Row to size itself
                      children: [
                        Icon(Icons.fire_extinguisher,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          // Wrap the Text in Expanded
                          child: Text(
                            l10n.availableExtinguishersTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            overflow: TextOverflow
                                .ellipsis, // Add overflow ellipsis if you don't want wrapping
                            maxLines: 1, // Optional: Limit to one line
                          ),
                        ),
                      ],
                    ),
                  ),
                  filteredProducts.when(
                    data: (items) => Text(
                      l10n.itemCount(items.length),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.7),
                          ),
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
                            color: Theme.of(context)
                                .hintColor, // Use theme hint color
                          ),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isEmpty
                                ? l10n
                                    .noExtinguishersAvailable // Localized message
                                : l10n
                                    .noExtinguishersMatchSearch, // Localized message
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium, // Use theme text style
                          ),
                          const SizedBox(height: 16),
                          if (searchQuery.isEmpty && isAdmin)
                            ElevatedButton.icon(
                              onPressed: () => _showCreateProductDialog(
                                  context, ref, l10n), // Pass l10n
                              icon: const Icon(Icons.add),
                              label: Text(l10n
                                  .addExtinguisherButton), // Localized button
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        color:
                            Theme.of(context).cardColor, // Use theme card color
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  product: product,
                                  onEdit: () => _showEditDialog(
                                      context, ref, product, l10n), // Pass l10n
                                  onDelete: () => _showDeleteConfirmation(
                                      context, ref, product, l10n), // Pass l10n
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product image or icon
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .highlightColor
                                        .withOpacity(
                                            0.1), // Use theme highlight color
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: product.imageUrl != null &&
                                            product.imageUrl!.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              product.imageUrl!,
                                              fit: BoxFit.cover,
                                              width: 70,
                                              height: 70,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Icon(
                                                Icons.fire_extinguisher,
                                                color: primaryColor,
                                                size: 32,
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.fire_extinguisher,
                                            color: primaryColor,
                                            size: 32,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Product details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ), // Use theme text style
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        product.type ??
                                            l10n.unknownType, // Localized
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color
                                                  ?.withOpacity(0.7),
                                            ), // Use theme text style
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.layers,
                                            size: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary, // Use secondary color
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            l10n.stockLabel(
                                                product.stockQuantity ??
                                                    0), // Localized
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ), // Use theme text style
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Action buttons
                                if (isAdmin)
                                  Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary), // Use secondary color
                                        onPressed: () => _showEditDialog(
                                            context,
                                            ref,
                                            product,
                                            l10n), // Pass l10n
                                        tooltip: l10n
                                            .editTooltip, // Localized tooltip
                                        constraints: BoxConstraints(
                                          minWidth: 36,
                                          minHeight: 36,
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error), // Use error color
                                        onPressed: () =>
                                            _showDeleteConfirmation(
                                                context,
                                                ref,
                                                product,
                                                l10n), // Pass l10n
                                        tooltip: l10n
                                            .deleteTooltip, // Localized tooltip
                                        constraints: BoxConstraints(
                                          minWidth: 36,
                                          minHeight: 36,
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Theme.of(context)
                              .colorScheme
                              .error, // Use theme error color
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.errorLoadingProducts, // Localized error message
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.error,
                                  ), // Use theme text style
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).hintColor,
                                  ), // Use theme text style and hint color
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () =>
                              _refreshData(context, ref, l10n), // Pass l10n
                          icon: const Icon(Icons.refresh),
                          label: Text(l10n.retryButton), // Localized button
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, // Use theme card color
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .shadowColor
                          .withOpacity(0.05), // Use theme shadow color
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left,
                          color: currentPage > 1
                              ? Theme.of(context).primaryColor
                              : Theme.of(context)
                                  .disabledColor), // Use theme colors
                      onPressed: currentPage > 1
                          ? () => ref
                              .read(currentPageProvider.notifier)
                              .update((state) => state - 1)
                          : null,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity(0.1), // Use primary color with opacity
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l10n.paginationPage(currentPage,
                            totalPages), // Localized pagination text
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context)
                                  .primaryColor, // Use theme primary color
                            ), // Use theme text style
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right,
                          color: currentPage < totalPages
                              ? Theme.of(context).primaryColor
                              : Theme.of(context)
                                  .disabledColor), // Use theme colors
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
