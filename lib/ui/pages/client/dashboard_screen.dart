import 'package:firetrack360/ui/pages/home/screens/base_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePlaceholderScreen(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
    );
  }
}
