import 'package:flutter/material.dart';
import 'package:firetrack360/generated/l10n.dart'; // Import localization

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!; // Access l10n here

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
        title: Text(
          l10n.logoutButton,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        tileColor: Colors.white.withOpacity(0.05),
      ),
    );
  }
}
