import 'package:firetrack360/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firetrack360/routes/auth_gateway.dart';
import 'package:intl/intl.dart';
import 'package:firetrack360/providers/notification_provider.dart';
import 'package:firetrack360/models/notification.dart' as AppNotification;
import 'package:firetrack360/generated/l10n.dart';

class NotificationPage extends ConsumerWidget {
  NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context)!;

    final userIdAsyncValue = ref.watch(userIdProvider);

    return AuthGateway(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: userIdAsyncValue.when(
            loading: () => Text(l10n.notifications_loadingUser),
            error: (err, stack) => Text(l10n.notifications_error),
            data: (userId) {
              final unreadCount = ref.watch(unreadCountProvider(userId!));

              return Row(
                children: [
                  Text(l10n.notifications_title),
                  const SizedBox(width: 8),
                  unreadCount.when(
                    loading: () => const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
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
            loading: () => [],
            error: (err, stack) => [],
            data: (userId) {
              final filterUnread = ref.watch(notificationFilterProvider);
              final notifier =
                  ref.read(notificationNotifierProvider(userId!).notifier);

              return [
                IconButton(
                  icon: Icon(
                      filterUnread ? Icons.filter_alt : Icons.filter_alt_off),
                  onPressed: () {
                    ref.read(notificationFilterProvider.notifier).state =
                        !filterUnread;
                  },
                  tooltip: filterUnread
                      ? l10n.tooltip_showAll
                      : l10n.tooltip_showUnread,
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => _markAllAsRead(context, notifier),
                      child: Row(
                        children: [
                          const Icon(Icons.mark_email_read),
                          const SizedBox(width: 8),
                          Text(l10n.menu_markAllAsRead),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => _refreshNotifications(notifier),
                      child: Row(
                        children: [
                          const Icon(Icons.refresh),
                          const SizedBox(width: 8),
                          Text(l10n.menu_refresh),
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
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.loading_userData),
                ],
              ),
            ),
            error: (err, stack) => _buildErrorState(context, null, err),
            data: (userId) {
              final notifications =
                  ref.watch(filteredNotificationsProvider(userId!));
              final filterUnread = ref.watch(notificationFilterProvider);
              final notifier =
                  ref.read(notificationNotifierProvider(userId!).notifier);

              return notifications.when(
                loading: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(l10n.loading_notifications),
                    ],
                  ),
                ),
                error: (err, stack) => _buildErrorState(context, notifier, err),
                data: (notificationList) {
                  if (notificationList.isEmpty) {
                    return _buildEmptyState(context, filterUnread);
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

  final userIdProvider =
      FutureProvider<String?>((ref) => AuthService.getUserId());

  Widget _buildEmptyState(BuildContext context, bool filterUnread) {
    final l10n = S.of(context)!;

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
            filterUnread
                ? l10n.emptyState_unreadTitle
                : l10n.emptyState_allTitle,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            filterUnread
                ? l10n.emptyState_unreadSubtitle
                : l10n.emptyState_allSubtitle,
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
    final l10n = S.of(context)!;

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
              l10n.errorState_title,
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
            if (notifier != null)
              ElevatedButton.icon(
                onPressed: () => notifier.loadNotifications(),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.errorState_retry),
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
    final l10n = S.of(context)!;

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              l10n.delete_swipeAction,
              style: const TextStyle(
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
                            _formatDateTime(context, notification.createdAt),
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
                                    l10n.highPriority_label,
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

  String _formatDateTime(BuildContext context, DateTime dateTime) {
    final l10n = S.of(context)!;
    final locale = Localizations.localeOf(context);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return l10n.date_justNow;
    } else if (difference.inHours < 1) {
      return l10n.date_minutesAgo(difference.inMinutes);
    } else if (difference.inDays < 1) {
      return l10n.date_hoursAgo(difference.inHours);
    } else if (difference.inDays < 7) {
      return l10n.date_daysAgo(difference.inDays);
    } else {
      return DateFormat('MMM dd, yyyy', locale.toString()).format(dateTime);
    }
  }

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    AppNotification.Notification notification,
  ) async {
    final l10n = S.of(context)!;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.deleteConfirmation_title),
        content: Text(l10n.deleteConfirmation_content(notification.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.button_cancel,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.button_delete),
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
    final l10n = S.of(context)!;

    // TODO: Implement delete functionality in your provider
    // notifier.deleteNotification(notification.id); // You would call a method like this
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.snackbar_notificationDeleted(notification.title)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: l10n.button_undo,
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
    final l10n = S.of(context)!;

    notifier.markAllAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.snackbar_markedAllAsRead),
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
