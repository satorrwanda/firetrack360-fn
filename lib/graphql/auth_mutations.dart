const String registerMutation = '''
  mutation Register(\$createUserInput: RegistrationInput!) {
    register(createUserInput: \$createUserInput) {
      message
      status
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

const String resendOtpMutation = '''
  mutation ResendVerificationOtp(\$email: String!) {
    resendVerificationOtp(email: \$email) {
      status
      message
    }
  }
''';
const String forgetPasswordMutation = '''
    mutation ForgetPassword(\$userEmail: String!) {
      forgetPassword(userEmail: \$userEmail) {
        message
        status
      }
    }
  ''';

const String replaceForgotPasswordMutation = '''
    mutation ReplaceForgotPassword(
      \$newPassword: String!
      \$confirmPassword: String!
      \$email: String!
      \$verificationToken: String!
    ) {
      replaceForgotPassword(
        newPasswordInput: {
          newPassword: \$newPassword
          confirmPassword: \$confirmPassword
          email: \$email
          verificationToken: \$verificationToken
        }
      ) {
        message
        status
      }
    }
  ''';

const String verifyLoginMutation = '''
  mutation VerifyLogin(\$email: String!, \$otp: String!) {
    verifyLogin(
      verifyLoginInput: {
        email: \$email,
        otp: \$otp
      }
    ) {
      message
      status
      accessToken
      refreshToken
    }
  }
''';
