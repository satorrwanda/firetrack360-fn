// Mutation to create a new product
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

// Mutation to delete an existing product
const String deleteProductMutation = r'''
  mutation DeleteProduct($productId: ID!) {
    deleteProduct(id: $productId) {
      id
      success
      message
    }
  }
''';

// Mutation to update an existing product
const String updateProductMutation = r'''
  mutation UpdateProduct($id: ID!, $productInput: ProductUpdateInput!) {  
  updateProduct(id: $id, productInput: $productInput) {
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
