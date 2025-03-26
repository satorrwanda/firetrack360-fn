import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firetrack360/providers/ServiceRequestProvider.dart';
import 'package:firetrack360/hooks/use_auth.dart';

class Technician {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;

  Technician({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory Technician.fromJson(Map<String, dynamic> json) {
    return Technician(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
    );
  }

  String get fullName => '$firstName $lastName';
}

class CreateServiceRequestModal extends ConsumerStatefulWidget {
  const CreateServiceRequestModal({super.key});

  @override
  ConsumerState<CreateServiceRequestModal> createState() =>
      _CreateServiceRequestModalState();
}

class _CreateServiceRequestModalState
    extends ConsumerState<CreateServiceRequestModal> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  final List<Technician> _technicians = [
    Technician(
      id: 'tech1',
      firstName: 'Technician',
      lastName: 'A',
      email: 'tech1@example.com',
      phone: '1234567890',
      role: 'technician',
    ),
    Technician(
      id: 'tech2',
      firstName: 'Technician',
      lastName: 'B',
      email: 'tech2@example.com',
      phone: '0987654321',
      role: 'technician',
    ),
    Technician(
      id: 'tech3',
      firstName: 'Technician',
      lastName: 'C',
      email: 'tech3@example.com',
      phone: '5555555555',
      role: 'technician',
    ),
  ];

  final List<String> _serviceOptions = [
    'Refill',
    'Maintenance',
    'Supply',
    'Other Services'
  ];
  String? _selectedService;
  Technician? _selectedTechnician;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final authState = useAuth();
      final userId = authState.userId;
      if (userId == null) throw Exception('User not authenticated');

      await ref
          .read(serviceRequestNotifierProvider.notifier)
          .createServiceRequest(
            title: _selectedService!,
            description: _descriptionController.text.trim(),
            clientId: userId,
            technicianId: _selectedTechnician!.id!,
          );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service request created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Service Request'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: const InputDecoration(
                  labelText: 'Select Service',
                  border: OutlineInputBorder(),
                ),
                items: _serviceOptions.map((service) {
                  return DropdownMenuItem(
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedService = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a service';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Technician>(
                value: _selectedTechnician,
                decoration: const InputDecoration(
                  labelText: 'Select Technician',
                  border: OutlineInputBorder(),
                ),
                items: _technicians.map((technician) {
                  return DropdownMenuItem(
                    value: technician,
                    child: Text('${technician.fullName} (${technician.phone})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedTechnician = value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a technician';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length > 500) {
                    return 'Description too long (max 500 characters)';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitForm,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }
}
