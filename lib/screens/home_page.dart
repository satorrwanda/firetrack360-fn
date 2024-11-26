import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fire Extinguisher Shop")),
      body: const Center(
        child: Text(
          "Welcome to the Fire Extinguisher Shop!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
