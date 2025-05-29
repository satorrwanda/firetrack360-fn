import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firetrack360/models/notification.dart';
import 'package:firetrack360/configs/graphql_client.dart';
import 'package:firetrack360/graphql/queries/notification_queries.dart';
import 'package:firetrack360/graphql/mutations/notification_mutations.dart';

final notificationFilterProvider = StateProvider<bool>((ref) => false);
final currentPageProvider = StateProvider<int>((ref) => 1);

final notificationNotifierProvider = StateNotifierProvider.family<
    NotificationNotifier, AsyncValue<List<Notification>>, String>((ref, userId) {
  return NotificationNotifier(ref, userId);
});

final filteredNotificationsProvider = Provider.family<
    AsyncValue<List<Notification>>, String>((ref, userId) {
  final filterUnread = ref.watch(notificationFilterProvider);
  final notifications = ref.watch(notificationNotifierProvider(userId));

  return notifications.when(
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
    data: (allNotifications) {
      if (!filterUnread) return AsyncValue.data(allNotifications);
      return AsyncValue.data(allNotifications.where((n) => !n.isRead).toList());
    },
  );
});

final unreadCountProvider = Provider.family<AsyncValue<int>, String>((ref, userId) {
  return ref.watch(notificationNotifierProvider(userId)).maybeWhen(
        data: (notifications) =>
            AsyncValue.data(notifications.where((n) => !n.isRead).length),
        orElse: () => const AsyncValue.loading(),
      );
});

class NotificationNotifier
    extends StateNotifier<AsyncValue<List<Notification>>> {
  final Ref ref;
  final String userId;

  NotificationNotifier(this.ref, this.userId)
      : super(const AsyncValue.loading()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = const AsyncValue.loading();
    try {
      final client = GraphQLConfiguration.initializeClient().value;
      final result = await client.query(QueryOptions(
        document: gql(getUserNotificationsQuery),
        variables: {'userId': userId},
      ));

      final List<Notification> notifications =
          (result.data?['notifications'] as List?)
                  ?.map((json) => Notification.fromJson(json))
                  .toList() ??
              [];

      state = AsyncValue.data(notifications);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final client = GraphQLConfiguration.initializeClient().value;
      await client.mutate(MutationOptions(
        document: gql(markAsReadMutation),
        variables: {'notificationId': notificationId},
      ));

      state.whenData((notifications) {
        state = AsyncValue.data([
          for (final n in notifications)
            n.id == notificationId ? n.copyWith(isRead: true) : n
        ]);
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final client = GraphQLConfiguration.initializeClient().value;
      await client.mutate(MutationOptions(
        document: gql(markAllAsReadMutation),
        variables: {'userId': userId},
      ));

      state.whenData((notifications) {
        state = AsyncValue.data(
          notifications.map((n) => n.copyWith(isRead: true)).toList(),
        );
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final client = GraphQLConfiguration.initializeClient().value;
      final result = await client.query(QueryOptions(
        document: gql(getUnreadCountQuery),
        variables: {'userId': userId},
      ));
      return result.data?['unreadNotificationCount'] ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
