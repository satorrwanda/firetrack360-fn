import 'package:firetrack360/ui/pages/home/screens/base_screen.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePlaceholderScreen(
      title: 'Navigation',
      icon: Icons.map_outlined,
    );
  }
}
