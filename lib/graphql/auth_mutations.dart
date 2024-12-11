 const String registerMutation = '''
  mutation Register(\$email: String!, \$phone: String!, \$password: String!, \$confirmPassword: String!) {
    register(
      createUserInput: {
        email: \$email
        phone: \$phone
        password: \$password
        confirmPassword: \$confirmPassword
      }
    ) {
      status
      message
    }
  }
  '''; 

const String verifyAccountMutation = r'''
    mutation VerifyAccount($email: String!, $otp: String!) {
      verifyAccount(
        verificationFields: { email: $email, otp: $otp }
      ) {
        message
        status
      }
    }
  ''';