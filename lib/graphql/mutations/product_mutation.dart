const String createProductMutation = r'''
  mutation CreateProduct($productInput: ProductInput!) {
    createProduct(productInput: $productInput) {
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
