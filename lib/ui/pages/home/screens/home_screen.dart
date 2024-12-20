import 'package:firetrack360/ui/pages/home/widgets/statistic_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          // Handle menu
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: StatisticCard(
                          icon: Icons.local_fire_department,
                          iconColor: Colors.orange,
                          label: 'Active Fires',
                          value: '12',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: StatisticCard(
                          icon: Icons.warning_outlined,
                          iconColor: Colors.red,
                          label: 'High Risk Areas',
                          value: '3',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: StatisticCard(
                          icon: Icons.people_outline,
                          iconColor: Colors.blue,
                          label: 'Response Teams',
                          value: '8',
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: StatisticCard(
                          icon: Icons.checklist_outlined,
                          iconColor: Colors.green,
                          label: 'Tasks Complete',
                          value: '85%',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ActivityItem(
            title: 'New fire detected',
            description: 'Fire detected in Sector A4',
            time: '2 hours ago',
            icon: Icons.local_fire_department,
            iconColor: Colors.orange,
            onTap: () {
              // Handle activity tap
            },
          ),
          ActivityItem(
            title: 'Team deployed',
            description: 'Response team Alpha dispatched to location',
            time: '3 hours ago',
            icon: Icons.directions_run,
            iconColor: Colors.blue,
            onTap: () {
              // Handle activity tap
            },
          ),
          ActivityItem(
            title: 'Risk assessment updated',
            description: 'Sector B2 risk level increased to high',
            time: '5 hours ago',
            icon: Icons.warning_outlined,
            iconColor: Colors.red,
            onTap: () {
              // Handle activity tap
            },
          ),
        ],
      ),
    );
  }
}