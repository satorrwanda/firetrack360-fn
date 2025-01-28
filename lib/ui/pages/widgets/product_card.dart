import 'package:firetrack360/models/product.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool canManageProducts;

  const ProductCard({
    super.key,
    required this.product,
    required this.canManageProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _navigateToProductDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductHeader(context),
              if (canManageProducts) _buildManagementButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget: Builds the product header with image and details
  Widget _buildProductHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        _buildProductImage(),
        const SizedBox(width: 16),
        
        // Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text('S/N: ${product.serialNumber}'),
              Text('Type: ${product.type} - ${product.size}'),
              Text('Stock: ${product.stockQuantity}'),
            ],
          ),
        ),
        
        // Product Price
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  // Widget: Builds the product image
  Widget _buildProductImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200], // Placeholder background color
      ),
      child: product.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.fire_extinguisher,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            )
          : const Icon(
              Icons.fire_extinguisher,
              size: 40,
              color: Colors.red,
            ),
    );
  }

  // Widget: Builds the management buttons (Edit/Delete)
  Widget _buildManagementButtons(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => _navigateToEditProduct(context),
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () => _showDeleteConfirmation(context),
              child: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }

  // Navigation: Go to product details page
  void _navigateToProductDetails(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/extinguisher-details',
      arguments: {
        'product': product,
        'canEdit': canManageProducts,
      },
    );
  }

  // Navigation: Go to edit product page
  void _navigateToEditProduct(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/edit-extinguisher',
      arguments: product,
    );
  }

  // Dialog: Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete mutation logic
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
