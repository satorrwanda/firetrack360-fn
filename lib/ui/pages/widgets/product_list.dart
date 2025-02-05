import 'package:firetrack360/models/product.dart';
import 'package:firetrack360/ui/pages/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final bool canManageProducts;

  const ProductList({
    super.key,
    required this.products,
    required this.canManageProducts,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          canManageProducts: canManageProducts,
          onTap: () {},
          onEdit: () {},
          onDelete: () {},
        );
      },
    );
  }
}