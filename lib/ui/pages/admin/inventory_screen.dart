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

// Define providers used in the screen (if not already defined elsewhere)
// Example:
// final currentPageProvider = StateProvider<int>((ref) => 1);
// final searchQueryProvider = StateProvider<String>((ref) => '');
// final totalPagesProvider = StateProvider<int>((ref) => 1); // Assuming this is calculated in your provider

class InventoryScreen extends HookConsumerWidget {
  const InventoryScreen({super.key});

  void _showCreateProductDialog(BuildContext context, WidgetRef ref, S l10n) {
    // Get theme-aware colors for the dialog
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBackgroundColor =
        isDarkMode ? Colors.deepPurple.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final primaryColor = Theme.of(context).primaryColor;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) => CreateProductDialog(
        uploadEndpoint: dotenv.env['FILE_UPLOAD_ENDPOINT']!,
        // Pass theme-aware colors to the dialog
        dialogBackgroundColor: cardBackgroundColor,
        dialogTextColor: textColor,
        dialogPrimaryColor: primaryColor,
        dialogOnPrimaryColor: onPrimaryColor,
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
                  backgroundColor:
                      Colors.green, // Keep standard snackbar colors
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
                  backgroundColor: Colors.red, // Keep standard snackbar colors
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
    // Get theme-aware colors for the dialog
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBackgroundColor =
        isDarkMode ? Colors.deepPurple.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final errorColor = Theme.of(context).colorScheme.error;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackgroundColor, // Use theme-aware background
        title: Text(l10n.deleteProductTitle,
            style: TextStyle(color: textColor)), // Use theme-aware text color
        content: Text(l10n.deleteProductConfirmation(product.name),
            style: TextStyle(color: textColor)), // Use theme-aware text color
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancelButton,
                style:
                    TextStyle(color: textColor)), // Use theme-aware text color
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
                      backgroundColor:
                          Colors.green, // Keep standard snackbar colors
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
                      backgroundColor:
                          Colors.red, // Keep standard snackbar colors
                    ),
                  );
                  Navigator.of(context).pop();
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: errorColor, // Use theme error color for emphasis
            ),
            child: Text(l10n.deleteButton), // Localized button
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, WidgetRef ref, Product product, S l10n) {
    // Get theme-aware colors for the dialog
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBackgroundColor =
        isDarkMode ? Colors.deepPurple.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final primaryColor = Theme.of(context).primaryColor;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditProductDialog(
        product: product,
        // Pass theme-aware colors to the dialog
        dialogBackgroundColor: cardBackgroundColor,
        dialogTextColor: textColor,
        dialogPrimaryColor: primaryColor,
        dialogOnPrimaryColor: onPrimaryColor,
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
                  backgroundColor:
                      Colors.green, // Keep standard snackbar colors
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
                  backgroundColor: Colors.red, // Keep standard snackbar colors
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
            backgroundColor: Colors.red, // Keep standard snackbar colors
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

    // Determine colors based on theme brightness, using deepPurple prominent
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appBarColor =
        isDarkMode ? Colors.deepPurple.shade900 : Colors.deepPurple;
    final gradientStartColor =
        isDarkMode ? Colors.deepPurple.shade900 : Colors.deepPurple.shade700;
    final gradientEndColor =
        isDarkMode ? Colors.black : Colors.deepPurple.shade400;
    final cardBackgroundColor =
        isDarkMode ? Colors.deepPurple.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor =
        isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final primaryColor = Theme.of(context).primaryColor; // Theme primary color
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final errorColor = Theme.of(context).colorScheme.error;
    final hintColor = Theme.of(context).hintColor;

    final authState = useAuth();
    var isAdmin = authState.userRole?.toLowerCase() == 'admin';

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Make Scaffold background transparent
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.inventory_2,
                color: onPrimaryColor), // Use theme-aware color
            SizedBox(width: 10),
            Text(
              l10n.inventoryTitle, // Localized title
              style: TextStyle(
                color: onPrimaryColor, // Use theme-aware color
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: appBarColor, // Use theme-aware color
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: onPrimaryColor), // Use theme-aware color
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () =>
                  _showCreateProductDialog(context, ref, l10n), // Pass l10n
              icon: const Icon(Icons.add),
              label: Text(l10n.newButton), // Localized label
              backgroundColor: primaryColor, // Use theme primary color
              foregroundColor: onPrimaryColor, // Use theme-aware color
            )
          : null,
      body: Container(
        // Add Container for the gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              gradientStartColor,
              gradientEndColor,
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => _refreshData(context, ref, l10n), // Pass l10n
          color: primaryColor, // Use theme primary color for refresh indicator
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  // Wrap TextField in Container for themed background and shadow
                  decoration: BoxDecoration(
                    color: cardBackgroundColor, // Use card background color
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .shadowColor
                            .withOpacity(isDarkMode ? 0.3 : 0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                      ref.read(currentPageProvider.notifier).state = 1;
                    },
                    decoration: InputDecoration(
                      hintText:
                          l10n.searchExtinguishersHint, // Localized hint text
                      hintStyle: TextStyle(
                          color: secondaryTextColor), // Use theme-aware color
                      prefixIcon: Icon(Icons.search,
                          color: textColor), // Use theme-aware color
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear,
                                  color: textColor), // Use theme-aware color
                              onPressed: () {
                                ref.read(searchQueryProvider.notifier).state =
                                    '';
                                ref.read(currentPageProvider.notifier).state =
                                    1;
                              },
                            )
                          : null,
                      border: InputBorder.none, // Remove default border
                      contentPadding: EdgeInsets.symmetric(
                          vertical:
                              12, // Adjusted vertical padding for better alignment
                          horizontal: 16),
                    ),
                    style: TextStyle(
                        color: textColor), // Use theme-aware text color
                  ),
                ),
              ),

              // Summary header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: cardBackgroundColor, // Use theme-aware color
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(
                          isDarkMode
                              ? 0.3
                              : 0.05), // Use theme-aware shadow color
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fire_extinguisher,
                              color: primaryColor), // Use theme primary color
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.availableExtinguishersTitle,
                              style: TextStyle(
                                color: textColor, // Use theme-aware text color
                                fontWeight: FontWeight.bold,
                                fontSize: 16, // Adjusted font size
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    filteredProducts.when(
                      data: (items) => Text(
                        l10n.itemCount(items.length),
                        style: TextStyle(
                          color: secondaryTextColor, // Use theme-aware color
                          fontSize: 14, // Adjusted font size
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
                              color:
                                  secondaryTextColor, // Use theme-aware color
                            ),
                            const SizedBox(height: 16),
                            Text(
                              searchQuery.isEmpty
                                  ? l10n
                                      .noExtinguishersAvailable // Localized message
                                  : l10n
                                      .noExtinguishersMatchSearch, // Localized message
                              style: TextStyle(
                                color: textColor, // Use theme-aware text color
                                fontSize: 18, // Adjusted font size
                              ),
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
                                  backgroundColor:
                                      primaryColor, // Use theme primary color
                                  foregroundColor:
                                      onPrimaryColor, // Use theme-aware color
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
                          color: cardBackgroundColor, // Use theme-aware color
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                    product: product,
                                    onEdit: () => _showEditDialog(context, ref,
                                        product, l10n), // Pass l10n
                                    onDelete: () => _showDeleteConfirmation(
                                        context,
                                        ref,
                                        product,
                                        l10n), // Pass l10n
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center, // Align vertically
                                children: [
                                  // Product image or icon
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(
                                          0.1), // Use primary color with opacity
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
                                          style: TextStyle(
                                            color:
                                                textColor, // Use theme-aware text color
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16, // Adjusted font size
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          product.type ??
                                              l10n.unknownType, // Localized
                                          style: TextStyle(
                                            color:
                                                secondaryTextColor, // Use theme-aware text color
                                            fontSize: 14, // Adjusted font size
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.layers,
                                              size: 16,
                                              color:
                                                  secondaryTextColor, // Use theme-aware color
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              l10n.stockLabel(
                                                  product.stockQuantity ??
                                                      0), // Localized
                                              style: TextStyle(
                                                color:
                                                    textColor, // Use theme-aware text color
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    14, // Adjusted font size
                                              ),
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
                                              color:
                                                  primaryColor), // Use primary color
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
                                              color:
                                                  errorColor), // Use theme error color
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                          primaryColor), // Use theme primary color
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
                            color: errorColor, // Use theme error color
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.errorLoadingProducts, // Localized error message
                            style: TextStyle(
                              color: textColor, // Use theme-aware text color
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjusted font size
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  secondaryTextColor, // Use theme-aware color
                              fontSize: 12, // Adjusted font size
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () =>
                                _refreshData(context, ref, l10n), // Pass l10n
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.retryButton), // Localized button
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  primaryColor, // Use theme primary color
                              foregroundColor:
                                  onPrimaryColor, // Use theme-aware color
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
                    color: cardBackgroundColor, // Use theme-aware color
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(
                            isDarkMode
                                ? 0.3
                                : 0.05), // Use theme-aware shadow color
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
                                ? primaryColor // Use theme primary color
                                : Theme.of(context)
                                    .disabledColor), // Use theme disabled color
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
                          color: primaryColor.withOpacity(
                              0.1), // Use primary color with opacity
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.paginationPage(currentPage,
                              totalPages), // Localized pagination text
                          style: TextStyle(
                            color: primaryColor, // Use theme primary color
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right,
                            color: currentPage < totalPages
                                ? primaryColor // Use theme primary color
                                : Theme.of(context)
                                    .disabledColor), // Use theme disabled color
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
      ),
    );
  }
}
