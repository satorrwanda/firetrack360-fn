import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountActivationPage extends StatefulWidget {
  const AccountActivationPage({super.key});

  @override
  _AccountActivationPageState createState() => _AccountActivationPageState();
}

class _AccountActivationPageState extends State<AccountActivationPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;
  String _email = '';

  // GraphQL Mutation
  static const String verifyAccountMutation = r'''
    mutation VerifyAccount($email: String!, $otp: String!) {
      verifyAccount(
        verificationFields: { email: $email, otp: $otp }
      ) {
        message
        status
      }
    }
  ''';

  void _activateAccount(GraphQLClient client) async {
    // Combine all inputs into a single string
    final activationCode = _controllers.map((c) => c.text).join();

    // Validate code length
    if (activationCode.length != 6) {
      _showErrorDialog('Please enter a valid 6-digit activation code.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await client.mutate(
        MutationOptions(
          document: gql(verifyAccountMutation),
          variables: {
            'email': _email, // Use email from shared preferences
            'otp': activationCode,
          },
        ),
      );

      setState(() => _isLoading = false);

      // Check mutation result
      if (result.hasException) {
        _showErrorDialog(result.exception?.graphqlErrors.first.message ?? 'Verification failed');
        return;
      }

      final verifyResult = result.data?['verifyAccount'];
      if (verifyResult['status'] == true) {
        // Successful verification, navigate to login
        Navigator.of(context).pushReplacementNamed('/login');
      } else {
        // Show error message from backend
        _showErrorDialog(verifyResult['message'] ?? 'Verification failed');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('An unexpected error occurred');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verification Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the GraphQL client
    final GraphQLClient client = GraphQLProvider.of(context).value;

    // Retrieve email from shared preferences
    _getEmailFromSharedPreferences();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade300,
                Colors.blue.shade700,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Activate Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter the 6-digit activation code sent to your email.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildCodeInputRow(),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () => _activateAccount(client),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'ACTIVATE ACCOUNT',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already activated? ',
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInputRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 48,
          child: TextField(
            controller: _controllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              // Removed hint text
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  _getEmailFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? '';
    });
  }
}