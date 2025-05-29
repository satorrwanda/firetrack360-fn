const String getUserNotificationsQuery = '''
  query Notifications(\$userId: ID!) {
    notifications(userId: \$userId) {
      id
      title
      message
      type
      priority
      recipientUserId
      isRead
      createdAt
      updatedAt
    }
  }
''';

const String getUnreadNotificationsQuery = '''
  query UnreadNotifications(\$userId: ID!) {
    unreadNotifications(userId: \$userId) {
      id
      title
      message
      type
      priority
      recipientUserId
      isRead
      createdAt
      updatedAt
    }
  }
''';

const String getUnreadCountQuery = '''
  query UnreadNotificationCount(\$userId: ID!) {
    unreadNotificationCount(userId: \$userId)
  }
''';
