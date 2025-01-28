import 'package:firetrack360/ui/pages/home/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firetrack360/ui/pages/home/widgets/custom_bottom_nav.dart';
import 'package:firetrack360/hooks/use_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnalyticsScreen extends HookWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = useAuth();

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter action
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        selectedIndex: 1,
        onIndexSelected: (index) {
          // Handle navigation based on index
        },
      ),
      body: CustomScrollView(
        slivers: [
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Fire Incidents Overview'),
                  const SizedBox(height: 16),
                  _buildMetricsGrid(),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Detailed Analysis'),
                  const SizedBox(height: 16),
                  _buildChartCard(
                    'Fire Incidents',
                    'Last 7 Days',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  _buildChartCard(
                    'Response Time',
                    'Average by Team',
                    Icons.timer,
                    Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildChartCard(
                    'Risk Distribution',
                    'By Area',
                    Icons.warning_rounded,
                    Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        userRole: authState.userRole,
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
    );
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard(
          'Total Incidents',
          '156',
          Icons.warning_amber_rounded,
          Colors.orange,
        ),
        _buildMetricCard(
          'Avg Response Time',
          '4.2 min',
          Icons.speed,
          Colors.green,
        ),
        _buildMetricCard(
          'High Risk Areas',
          '23',
          Icons.location_on,
          Colors.red,
        ),
        _buildMetricCard(
          'Active Teams',
          '12',
          Icons.group,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Handle more options
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Chart placeholder'),
            ),
          ),
        ],
      ),
    );
  }
}
