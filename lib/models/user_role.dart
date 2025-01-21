enum UserRole {
  CLIENT,
  ADMIN,
  MANAGER;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.toString().split('.').last == role,
      orElse: () => UserRole.CLIENT,
    );
  }
}