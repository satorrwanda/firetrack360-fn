class Product {
  final String id;
  final String name;
  final String serialNumber;
  final String type;
  final String size;
  final String description;
  final double price;
  final int stockQuantity;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.type,
    required this.size,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      serialNumber: json['serialNumber'],
      type: json['type'],
      size: json['size'],
      description: json['description'],
      price: json['price'],
      stockQuantity: json['stockQuantity'],
      imageUrl: json['imageUrl'],
    );
  }
}
