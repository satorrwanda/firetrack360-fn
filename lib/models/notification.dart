class Notification {
  final String id;
  final String title;
  final String message;
  final String type;
  final String priority;
  final String recipientUserId;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.recipientUserId,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json['id'],
        title: json['title'],
        message: json['message'],
        type: json['type'],
        priority: json['priority'],
        recipientUserId: json['recipientUserId'],
        isRead: json['isRead'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Notification copyWith({
    bool? isRead,
    DateTime? updatedAt,
  }) =>
      Notification(
        id: id,
        title: title,
        message: message,
        type: type,
        priority: priority,
        recipientUserId: recipientUserId,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}