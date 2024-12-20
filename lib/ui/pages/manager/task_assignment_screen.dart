import 'package:firetrack360/ui/pages/home/screens/base_screen.dart';
import 'package:flutter/material.dart';

class TaskAssignmentScreen extends StatelessWidget {
  const TaskAssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePlaceholderScreen(
      title: 'Task Assignment',
      icon: Icons.assignment_turned_in_outlined,
    );
  }
}
