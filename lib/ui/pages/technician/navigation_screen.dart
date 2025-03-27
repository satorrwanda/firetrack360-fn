import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Demo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Map will be added here later.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchGoogleMaps,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.navigation, color: Colors.white),
      ),
    );
  }

  Future<void> _launchGoogleMaps() async {
    final uri = Uri.parse('https://www.google.com/maps');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Google Maps')),
      );
    }
  }
}
