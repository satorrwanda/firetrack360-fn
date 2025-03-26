import 'package:firetrack360/models/technician.dart';
class Invoice {
  final String status;
  final double totalAmount;

  Invoice({
    required this.status,
    required this.totalAmount,
  });
}
class ServiceRequest {
  final String id;
  final String title;
  final String description;
  final DateTime requestDate;
  final String status;
  final Technician technician;
  final Technician? client;
  final Invoice? invoice;

  ServiceRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.requestDate,
    required this.status,
    required this.technician,
    this.client,
    this.invoice,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      requestDate: DateTime.parse(json['requestDate'] as String),
      status: json['status'] as String,
      technician:
          Technician.fromJson(json['technician'] as Map<String, dynamic>),
      client: json['client'] != null
          ? Technician.fromJson(json['client'] as Map<String, dynamic>)
          : null,
    );
  }
}
