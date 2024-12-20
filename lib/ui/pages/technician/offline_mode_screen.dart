import 'package:firetrack360/ui/pages/home/screens/base_screen.dart';
import 'package:flutter/material.dart';

class OfflineModeScreen extends StatelessWidget {
  const OfflineModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePlaceholderScreen(
      title: 'Offline Mode',
      icon: Icons.offline_bolt_outlined,
    );
  }
}
