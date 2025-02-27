class ServiceRequest {
  final String id;
  final String title;
  final String description;
  final DateTime requestDate;
  final DateTime? scheduledDate;
  final DateTime? completionDate;
  final String status;
  final Contact technician;
  final Contact client;
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
      id: json['id'],
      title: json['title'],
      description: json['description'],
      requestDate: DateTime.parse(json['requestDate']),
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : null,
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      status: json['status'],
      technician: Contact.fromJson(json['technician']),
      client: Contact.fromJson(json['client']),
      invoice:
          json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null,
    );
  }
}

class Contact {
  final String email;
  final String phone;
  final String? name;

  Contact({
    required this.email,
    required this.phone,
    this.name,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      email: json['email'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String?,
    );
  }
}

class Invoice {
  final String status;
  final double totalAmount;
  final DateTime? dueDate;
  final String? invoiceNumber;

  Invoice({
    required this.status,
    required this.totalAmount,
    this.dueDate,
    this.invoiceNumber,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      status: json['status'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      invoiceNumber: json['invoiceNumber'] as String?,
    );
  }
}

class Technician {
  final String id;
  final String name;
  final String email;
  final String phone;

  Technician(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone});

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}

class Client {
  final String id;
  final String name;
  final String email;
  final String phone;

  Client(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
