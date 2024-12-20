import 'package:firetrack360/ui/pages/home/screens/base_screen.dart';
import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePlaceholderScreen(
      title: 'Payments',
      icon: Icons.payment_outlined,
    );
  }
}
