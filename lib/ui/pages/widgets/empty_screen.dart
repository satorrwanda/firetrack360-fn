import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final bool showAddButton;
  final VoidCallback? onAddPressed;

  const EmptyScreen({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.showAddButton = false,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (showAddButton && onAddPressed != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onAddPressed,
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Extinguisher'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}