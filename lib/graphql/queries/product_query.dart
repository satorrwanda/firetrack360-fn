const String getAllProductsQuery = r'''
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
''';
