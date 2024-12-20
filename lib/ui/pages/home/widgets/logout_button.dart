import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        onTap: onLogout,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: const Icon(
          Icons.logout,
          color: Colors.white70,
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        tileColor: Colors.white.withOpacity(0.05),
      ),
    );
  }
}
