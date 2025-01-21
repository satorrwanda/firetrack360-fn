class Product {
  final String id;
  final String name;
  final String serialNumber;
  final String type;
  final String size;
  final String description;
  final double price;
  final int stockQuantity;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.type,
    required this.size,
    required this.description,
    required this.price,
    required this.stockQuantity,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      serialNumber: json['serialNumber'] as String,
      type: json['type'] as String,
      size: json['size'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      stockQuantity: json['stockQuantity'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}