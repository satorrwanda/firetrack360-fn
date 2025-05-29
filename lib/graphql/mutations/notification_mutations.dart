const String markAsReadMutation = '''
  mutation MarkAsRead(\$notificationId: ID!) {
    markAsRead(notificationId: \$notificationId) {
      id
      isRead
      updatedAt
    }
  }
''';

const String markAllAsReadMutation = '''
  mutation MarkAllAsRead(\$userId: ID!) {
    markAllAsRead(userId: \$userId)
  }
''';
