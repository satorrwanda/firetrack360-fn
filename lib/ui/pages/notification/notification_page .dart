import 'package:firetrack360/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firetrack360/routes/auth_gateway.dart';
import 'package:intl/intl.dart';
import 'package:firetrack360/providers/notification_provider.dart';
import 'package:firetrack360/models/notification.dart' as AppNotification;

class NotificationPage extends ConsumerWidget {
  // Use ConsumerWidget
  NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use a FutureProvider to get the userId asynchronously
    final userIdAsyncValue = ref.watch(userIdProvider);

    return AuthGateway(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: userIdAsyncValue.when(
            loading: () => const Text('Notifications (Loading User...)'),
            error: (err, stack) => const Text('Notifications (Error)'),
            data: (userId) {
              // Watch the unread count only when userId is available
              final unreadCount = ref.watch(unreadCountProvider(
                  userId!)); // Use userId! assuming it's non-null here

              return Row(
                children: [
                  const Text('Notifications'),
                  const SizedBox(width: 8),
                  unreadCount.when(
                    loading: () => const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors
                              .white), // Use white color for visibility on AppBar
                    ),
                    error: (_, __) => const SizedBox(),
                    data: (count) => count > 0
                        ? Badge(
                            label: Text('$count'),
                            backgroundColor: Colors.white,
                            textColor: Colors.deepPurple,
                          )
                        : const SizedBox(),
                  ),
                ],
              );
            },
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: userIdAsyncValue.when(
            loading: () => [], // No actions while loading user ID
            error: (err, stack) => [], // No actions on error
            data: (userId) {
              final filterUnread = ref.watch(notificationFilterProvider);
              final notifier = ref.read(notificationNotifierProvider(userId!)
                  .notifier); // Use userId!

              return [
                IconButton(
                  icon: Icon(
                      filterUnread ? Icons.filter_alt : Icons.filter_alt_off),
                  onPressed: () {
                    ref.read(notificationFilterProvider.notifier).state =
                        !filterUnread;
                  },
                  tooltip: filterUnread ? 'Show All' : 'Show Unread Only',
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => _markAllAsRead(context, notifier),
                      child: const Row(
                        children: [
                          Icon(Icons.mark_email_read),
                          SizedBox(width: 8),
                          Text('Mark All as Read'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => _refreshNotifications(notifier),
                      child: const Row(
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 8),
                          Text('Refresh'),
                        ],
                      ),
                    ),
                  ],
                ),
              ];
            },
          ),
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
          child: userIdAsyncValue.when(
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading user data...'),
                ],
              ),
            ),
            error: (err, stack) => _buildErrorState(
                context, null, err), // Pass null notifier for initial error
            data: (userId) {
              // Watch the filtered notifications only when userId is available
              final notifications = ref
                  .watch(filteredNotificationsProvider(userId!)); // Use userId!
              final filterUnread = ref.watch(notificationFilterProvider);
              final notifier = ref.read(notificationNotifierProvider(userId!)
                  .notifier); // Use userId!

              return notifications.when(
                loading: () => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading notifications...'),
                    ],
                  ),
                ),
                error: (err, stack) => _buildErrorState(context, notifier, err),
                data: (notificationList) {
                  if (notificationList.isEmpty) {
                    return _buildEmptyState(filterUnread);
                  }

                  return RefreshIndicator(
                    onRefresh: () => notifier.loadNotifications(),
                    color: Colors.deepPurple,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: notificationList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final notification = notificationList[index];
                        return _buildNotificationItem(
                          context,
                          notification,
                          notifier,
                          ref,
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper function to create a FutureProvider for the userId
  final userIdProvider =
      FutureProvider<String?>((ref) => AuthService.getUserId());

  Widget _buildEmptyState(bool filterUnread) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            filterUnread ? Icons.mark_email_read : Icons.notifications_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            filterUnread ? 'No unread notifications' : 'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            filterUnread
                ? 'All caught up! 🎉'
                : 'Notifications will appear here when you receive them',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context, NotificationNotifier? notifier, Object error) {
    // Made notifier nullable
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (notifier !=
                null) // Only show refresh button if notifier is available
              ElevatedButton.icon(
                onPressed: () => notifier.loadNotifications(),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    AppNotification.Notification notification,
    NotificationNotifier notifier,
    WidgetRef ref,
  ) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) =>
          _showDeleteConfirmation(context, notification),
      onDismissed: (direction) =>
          _handleDelete(context, notification, notifier),
      child: Card(
        elevation: notification.isRead ? 1 : 3,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: notification.isRead
              ? BorderSide.none
              : BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleNotificationTap(notification, notifier),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: notification.isRead
                  ? Colors.white
                  : Colors.deepPurple.withOpacity(0.02),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getNotificationColor(notification.type)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                                fontSize: 16,
                                color: notification.isRead
                                    ? Colors.grey[700]
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: const BoxDecoration(
                                color: Colors.deepPurple,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDateTime(notification.createdAt),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          if (notification.priority == 'HIGH')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.priority_high,
                                    size: 12,
                                    color: Colors.red[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'High Priority',
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type.toUpperCase()) {
      case 'ALERT':
        return Colors.red.shade500;
      case 'WARNING':
        return Colors.orange.shade500;
      case 'INFO':
        return Colors.blue.shade500;
      case 'SUCCESS':
        return Colors.green.shade500;
      default:
        return Colors.grey.shade500;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toUpperCase()) {
      case 'ALERT':
        return Icons.warning_rounded;
      case 'WARNING':
        return Icons.error_outline_rounded;
      case 'INFO':
        return Icons.info_outline_rounded;
      case 'SUCCESS':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(dateTime);
    }
  }

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    AppNotification.Notification notification,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Notification'),
        content:
            Text('Are you sure you want to delete "${notification.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleDelete(
    BuildContext context,
    AppNotification.Notification notification,
    NotificationNotifier notifier,
  ) {
    // TODO: Implement delete functionality in your provider
    // notifier.deleteNotification(notification.id); // You would call a method like this
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${notification.title}"'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // TODO: Implement undo functionality (if possible with your API)
          },
        ),
      ),
    );
  }

  void _handleNotificationTap(
    AppNotification.Notification notification,
    NotificationNotifier notifier,
  ) {
    if (!notification.isRead) {
      notifier.markAsRead(notification.id);
    }

    // TODO: Handle navigation based on notification type/data
    // Example: Navigate to specific screens based on notification content
  }

  void _markAllAsRead(BuildContext context, NotificationNotifier notifier) {
    notifier.markAllAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _refreshNotifications(NotificationNotifier notifier) {
    notifier.loadNotifications();
  }
}
