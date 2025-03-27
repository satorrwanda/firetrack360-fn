import 'package:firetrack360/models/technician.dart';

class ServiceRequest {
  final String id;
  final String title;
  final String description;
  final DateTime requestDate;
  final DateTime? scheduledDate;
  final DateTime? completionDate;
  final String status;
  final Technician technician;
  final Technician client;
  final Invoice? invoice;

  ServiceRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.requestDate,
    this.scheduledDate,
    this.completionDate,
    required this.status,
    required this.technician,
    required this.client,
    this.invoice,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      requestDate: DateTime.parse(
          json['requestDate'] as String? ?? DateTime.now().toString()),
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : null,
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      status: json['status'] as String? ?? 'REQUESTED',
      technician: Technician.fromJson(json['technician'] ?? {}),
      client: Technician.fromJson(json['client'] ?? {}),
      invoice:
          json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null,
    );
  }
}

class Invoice {
  final String? id;
  final double? totalAmount;
  final DateTime? issuedAt;
  final DateTime? dueDate;
  final String? status;

  Invoice({
    this.id,
    this.totalAmount,
    this.issuedAt,
    this.dueDate,
    this.status,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String?,
      totalAmount: json['totalAmount'] as double?,
      issuedAt: json['issuedAt'] != null
          ? DateTime.parse(json['issuedAt'] as String)
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      status: json['status'] as String?,
    );
  }
}
