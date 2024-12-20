import 'package:firetrack360/ui/pages/home/widgets/statistic_card.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics Dashboard',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          ChartCard(
            title: 'Fire Incidents',
            subtitle: 'Last 7 Days',
            chart: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Chart placeholder'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ChartCard(
            title: 'Response Time',
            subtitle: 'Average by Team',
            chart: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Chart placeholder'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ChartCard(
            title: 'Risk Distribution',
            subtitle: 'By Area',
            chart: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('Chart placeholder'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}