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

const String loginMutation = r'''
    mutation Login($email: String!, $password: String!) {
      login(loginInput: { email: $email, password: $password }) {
        message
        status
      }
    }
  ''';

  const String verifyLoginMutation = r'''
    mutation VerifyLogin($email: String!, $otp: String!) {
      verifyLogin(verifyLoginInput: { email: $email, otp: $otp }) {
        message
        status
        accessToken
        refreshToken
      }
    }
  ''';
