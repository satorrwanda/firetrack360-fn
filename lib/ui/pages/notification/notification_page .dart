import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firetrack360/hooks/use_auth.dart';
import 'package:firetrack360/routes/auth_gateway.dart';
import 'package:intl/intl.dart';

class NotificationPage extends HookWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    useAuth();
    final notifications =
        useState<List<NotificationItem>>(_generateMockNotifications());

    return AuthGateway(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Notifications'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterDialog(context, notifications),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepPurple.withOpacity(0.05),
                Colors.white,
              ],
            ),
          ),
          child: _buildNotificationList(notifications.value),
        ),
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationItem> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Text('No notifications available'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        notifications = _generateMockNotifications();
      },
      color: Colors.deepPurple,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleNotificationTap(notification),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('MMM dd, yyyy - hh:mm a')
                          .format(notification.date),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (notification.isUnread)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.alert:
        return Colors.red.shade400;
      case NotificationType.warning:
        return Colors.orange.shade400;
      case NotificationType.info:
        return Colors.deepPurple.shade400;
      case NotificationType.success:
        return Colors.green.shade400;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.alert:
        return Icons.warning_amber;
      case NotificationType.warning:
        return Icons.error_outline;
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.success:
        return Icons.check_circle_outline;
      default:
        return Icons.notifications_none;
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    // Handle navigation based on notification type
    // You can implement this based on your app's navigation structure
    print('Notification tapped: ${notification.id}');
  }

  Future<void> _showFilterDialog(BuildContext context,
      ValueNotifier<List<NotificationItem>> notifications) {
    final filters = {
      'All': true,
      'Alerts': true,
      'Warnings': true,
      'Info': true,
      'Success': true,
      'Unread only': false,
    };

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Filter Notifications',
                style: TextStyle(color: Colors.deepPurple.shade700),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: filters.entries.map((entry) {
                  return CheckboxListTile(
                    title: Text(entry.key),
                    value: entry.value,
                    activeColor: Colors.deepPurple,
                    onChanged: (value) {
                      setState(() {
                        filters[entry.key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                  ),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Apply filters
                    notifications.value =
                        _generateMockNotifications().where((n) {
                      if (filters['Unread only']! && !n.isUnread) return false;
                      if (!filters['All']!) {
                        if (n.type == NotificationType.alert &&
                            !filters['Alerts']!) {
                          return false;
                        }
                        if (n.type == NotificationType.warning &&
                            !filters['Warnings']!) {
                          return false;
                        }
                        if (n.type == NotificationType.info &&
                            !filters['Info']!) {
                          return false;
                        }
                        if (n.type == NotificationType.success &&
                            !filters['Success']!) {
                          return false;
                        }
                      }
                      return true;
                    }).toList();
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                  ),
                  child: const Text('Apply'),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            );
          },
        );
      },
    );
  }

  static List<NotificationItem> _generateMockNotifications() {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: '1',
        title: 'Fire Extinguisher Expired',
        message:
            'Fire extinguisher in Main Hall has expired. Please replace immediately.',
        type: NotificationType.alert,
        date: now.subtract(const Duration(minutes: 5)),
        isUnread: true,
      ),
      NotificationItem(
        id: '2',
        title: 'Scheduled Maintenance',
        message:
            'Quarterly maintenance for all fire alarms is scheduled for next week.',
        type: NotificationType.info,
        date: now.subtract(const Duration(hours: 2)),
        isUnread: true,
      ),
      NotificationItem(
        id: '3',
        title: 'Battery Low',
        message: 'Battery in smoke detector (Room 203) is running low.',
        type: NotificationType.warning,
        date: now.subtract(const Duration(days: 1)),
        isUnread: false,
      ),
      NotificationItem(
        id: '4',
        title: 'Inspection Completed',
        message: 'Annual fire safety inspection completed successfully.',
        type: NotificationType.success,
        date: now.subtract(const Duration(days: 3)),
        isUnread: false,
      ),
      NotificationItem(
        id: '5',
        title: 'New Safety Regulations',
        message:
            'Updated fire safety regulations are now available in the documents section.',
        type: NotificationType.info,
        date: now.subtract(const Duration(days: 5)),
        isUnread: false,
      ),
    ];
  }
}

enum NotificationType {
  alert,
  warning,
  info,
  success,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime date;
  final bool isUnread;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    this.isUnread = false,
  });
}
