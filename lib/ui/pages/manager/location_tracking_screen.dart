import 'package:firetrack360/ui/pages/home/screens/base_screen.dart';
import 'package:flutter/material.dart';

class LocationTrackingScreen extends StatelessWidget {
  const LocationTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePlaceholderScreen(
      title: 'Location Tracking',
      icon: Icons.location_on_outlined,
    );
  }
}
