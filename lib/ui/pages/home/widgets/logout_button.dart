import 'package:flutter/material.dart';
import 'package:firetrack360/generated/l10n.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final theme = Theme.of(context);

    const backgroundColor = Colors.deepPurple;
    final foregroundColor = theme.colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        onTap: onLogout,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Icon(
          Icons.logout,
          color: foregroundColor,
        ),
        // Wrap the title in a Row with MainAxisAlignment.center
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the content of the Row
          children: [
            // Use Expanded to allow the Text to take available space within the Row
            Expanded(
              child: Text(
                l10n.logoutButton,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        tileColor: backgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
