enum VerificationStatus {
  success,
  invalidOTP,
  expired,
  error,
}

class VerificationResult {
  final VerificationStatus status;
  final String message;
  final String? accessToken;
  final String? refreshToken;

  VerificationResult({
    required this.status,
    required this.message,
    this.accessToken,
    this.refreshToken,
  });
}