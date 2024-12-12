import 'package:firetrack360/graphql/auth_mutations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyLoginPage extends StatefulWidget {
  const VerifyLoginPage({super.key});

  @override
  State<VerifyLoginPage> createState() => _VerifyLoginPageState();
}

class _VerifyLoginPageState extends State<VerifyLoginPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      if (mounted) {
        setState(() {
          _email = email;
        });
      }
      if (email == null) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
          _showErrorSnackBar('Session expired. Please login again.');
        }
      }
    } catch (e) {
      debugPrint('Error loading email: $e');
      if (mounted) {
        _showErrorSnackBar('Error loading session data');
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    if (_email == null) {
      _showErrorSnackBar('Session expired. Please login again.');
      return;
    }

    final otp = _controllers.map((c) => c.text).join();

    if (otp.length != 6) {
      _showErrorSnackBar('Please enter all 6 digits of the OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final client = GraphQLProvider.of(context).value;
      final result = await client.mutate(
        MutationOptions(
          document: gql(verifyLoginMutation),
          variables: {
            'verifyLoginInput': {
              'email': _email,
              'otp': otp,
            },
          },
        ),
      );

      if (result.hasException) {
        _handleGraphQLError(result.exception!);
        return;
      }

      final data = result.data?['verifyLogin'];
      if (data != null && (data['status'] == 200 || data['status'] == 201)) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['accessToken']);
        await prefs.setString('refreshToken', data['refreshToken']);
        
        if (mounted) {
          _showSuccessSnackBar(data['message'] ?? 'Login verified successfully');
          // Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _showErrorSnackBar(data?['message'] ?? 'Verification failed. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred. Please try again.');
      debugPrint('Verification error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleGraphQLError(OperationException exception) {
    String errorMessage = 'Verification failed. Please try again.';

    if (exception.graphqlErrors.isNotEmpty) {
      final firstError = exception.graphqlErrors.first;
      final errorCode = firstError.extensions?['status'] as int?;

      switch (errorCode) {
        case 400:
          errorMessage = 'Invalid OTP. Please check and try again.';
          break;
        case 401:
          errorMessage = 'OTP has expired. Please request a new one.';
          break;
        default:
          errorMessage = firstError.message;
      }
    }

    _showErrorSnackBar(errorMessage);
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_email == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6741D9),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Login'),
        elevation: 0,
        backgroundColor: const Color(0xFF6741D9),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.security,
                size: 64,
                color: Color(0xFF6741D9),
              ),
              const SizedBox(height: 24),
              Text(
                'Two-Factor Authentication',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6741D9),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Enter the 6-digit code sent to your email\n$_email',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    height: 55,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF6741D9),
                            width: 2,
                          ),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        _showSuccessSnackBar('New OTP sent to your email');
                      },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6741D9),
                ),
                child: const Text(
                  'Resend Code',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}