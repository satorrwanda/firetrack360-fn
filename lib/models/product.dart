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
    try {
      // Validate required fields are not null
      if (json['serialNumber'] == null) throw Exception('serialNumber is null');
      if (json['type'] == null) throw Exception('type is null');
      if (json['size'] == null) throw Exception('size is null');

      return Product(
        id: json['id'] as String,
        name: json['name'] as String,
        serialNumber: json['serialNumber'] as String,
        type: json['type'] as String,
        size: json['size'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        stockQuantity: json['stockQuantity'] as int,
        imageUrl: _validateImageUrl(json['imageUrl'] as String?),
      );
    } catch (e) {
      print('Error parsing product JSON: $json');
      print('Error details: $e');
      rethrow;
    }
  }

  static String _validateImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      // Return a default placeholder image URL if the URL is null or empty
      return 'assets/images/placeholder_product.png';
    }

    // Validate URL format
    try {
      final uri = Uri.parse(url);
      if (!uri.isAbsolute) {
        return 'assets/images/placeholder_product.png';
      }
      return url;
    } catch (e) {
      return 'assets/images/placeholder_product.png';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'serialNumber': serialNumber,
        'type': type,
        'size': size,
        'description': description,
        'price': price,
        'stockQuantity': stockQuantity,
        'imageUrl': imageUrl,
      };
}
