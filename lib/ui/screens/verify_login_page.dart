import 'dart:async';
import 'package:firetrack360/routes/app_routes.dart';
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
  Timer? _resendTimer;
  int _remainingTime = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadEmail();
    _startResendTimer();
  }

  void _startResendTimer() {
    _remainingTime = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _loadEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      
      if (mounted) {
        setState(() {
          _email = email;
          _isInitialized = true;
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
        setState(() => _isInitialized = true);
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
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _resendOTP() async {
    if (_remainingTime > 0 || _email == null || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final client = GraphQLProvider.of(context).value;
      final result = await client.mutate(
        MutationOptions(
          document: gql('''
            mutation ResendOTP(\$email: String!) {
              resendOTP(email: \$email) {
                status
                message
              }
            }
          '''),
          variables: {
            'email': _email!,
          },
        ),
      );

      if (result.hasException) {
        _handleGraphQLError(result.exception!);
        return;
      }

      final data = result.data?['resendOTP'];
      if (data != null && data['status'] == 200) {
        _showSuccessSnackBar(data['message'] ?? 'New OTP sent to your email');
        _startResendTimer();
        // Clear existing OTP fields
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes.first.requestFocus();
      } else {
        _showErrorSnackBar(data?['message'] ?? 'Failed to resend OTP');
      }
    } catch (e) {
      debugPrint('Resend OTP error: $e');
      _showErrorSnackBar('Failed to resend OTP');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyOTP() async {
    if (_email == null || _isLoading) {
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
          document: gql('''
            mutation VerifyLogin(\$verifyLoginInput: VerifyLoginInput!) {
              verifyLogin(verifyLoginInput: \$verifyLoginInput) {
                status
                message
                accessToken
                refreshToken
              }
            }
          '''),
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
      if (data != null) {
        switch (data['status']) {
          case 200:
          case 201:
            await _handleSuccessfulVerification(data);
            break;
          case 400:
            _showErrorSnackBar('Invalid OTP. Please try again.');
            break;
          case 401:
            _showErrorSnackBar('OTP expired. Please request a new one.');
            break;
          default:
            _showErrorSnackBar(data['message'] ?? 'Verification failed.');
        }
      } else {
        _showErrorSnackBar('Verification failed. Please try again.');
      }
    } catch (e) {
      debugPrint('Verification error: $e');
      _showErrorSnackBar('An unexpected error occurred');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSuccessfulVerification(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([
        prefs.setString('accessToken', data['accessToken']),
        prefs.setString('refreshToken', data['refreshToken']),
      ]);

      if (mounted) {
        _showSuccessSnackBar(data['message'] ?? 'Login verified successfully');
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          AppRoutes.navigateToHome(context);
        }
      }
    } catch (e) {
      debugPrint('Error saving tokens: $e');
      _showErrorSnackBar('Error saving authentication data');
    }
  }

  void _handleGraphQLError(OperationException exception) {
    String errorMessage = 'Verification failed. Please try again.';

    if (exception.graphqlErrors.isNotEmpty) {
      final firstError = exception.graphqlErrors.first;
      final dynamic extensions = firstError.extensions;
      final errorCode = extensions?['status'] as int?;

      switch (errorCode) {
        case 400:
          errorMessage = 'Invalid OTP. Please check and try again.';
          break;
        case 401:
          errorMessage = 'OTP has expired. Please request a new one.';
          break;
        case 404:
          errorMessage = 'Email not found. Please try logging in again.';
          break;
        case 429:
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        default:
          errorMessage = firstError.message;
      }
    } else if (exception.linkException != null) {
      errorMessage = 'Network error. Please check your connection.';
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

  Widget _buildOTPField(int index) {
    return SizedBox(
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
          if (value.isNotEmpty) {
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              _focusNodes[index].unfocus();
              final allFilled = _controllers.every(
                  (controller) => controller.text.isNotEmpty);
              if (allFilled) {
                _verifyOTP();
              }
            }
          } else if (index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
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
                'Enter the 6-digit code sent to your email\n${_email ?? ""}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, _buildOTPField),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading || _email == null ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6741D9),
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
                onPressed: _isLoading || _remainingTime > 0 || _email == null
                    ? null
                    : _resendOTP,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6741D9),
                ),
                child: Text(
                  _remainingTime > 0
                      ? 'Resend Code in ${_remainingTime}s'
                      : 'Resend Code',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    color: _remainingTime > 0 || _email == null || _isLoading
                        ? Colors.grey
                        : const Color(0xFF6741D9),
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