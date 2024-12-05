const String registerMutation = """
mutation Register(\$email: String!, \$phone: String!, \$password: String!, \$confirmPassword: String!) {
  register(createUserInput: {
    email: \$email,
    phone: \$phone,
    password: \$password,
    confirmPassword: \$confirmPassword
  }) {
    message
    status
  }
}
""";
