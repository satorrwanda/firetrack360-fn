import 'package:flutter/material.dart';

class BasePlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget>? actions;
  final String? description;
  final Widget? customContent;

  const BasePlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
    this.actions,
    this.description,
    this.customContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (actions != null) Row(children: actions!),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: customContent ?? _buildDefaultContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultContent(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Icon(
                icon,
                size: 72,
                color: Theme.of(context).primaryColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              description ?? 'This screen is under development',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
