import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String title;

  const LoadingScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}