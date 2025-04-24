import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:firetrack360/configs/graphql_client.dart';
import 'package:firetrack360/graphql/queries/profile_query.dart';
import 'package:firetrack360/models/technician.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/providers/ServiceRequestProvider.dart';

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
  bool _isLoadingTechnicians = false;
  String? _errorMessage;

  final List<String> _serviceOptions = [
    'Refill',
    'Maintenance',
    'Supply',
    'Other Services'
  ];
  String? _selectedService;
  Technician? _selectedTechnician;
  List<Technician> _technicians = [];

  @override
  void initState() {
    super.initState();
    _loadTechnicians();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadTechnicians() async {
    if (_isLoadingTechnicians) return;

    setState(() {
      _isLoadingTechnicians = true;
      _errorMessage = null;
    });

    try {
      final client = GraphQLConfiguration.initializeClient().value;
      final result = await client.query(
        QueryOptions(
          document: gql(getAvailableTechniciansQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw _handleGraphQLError(result.exception);
      }

      if (result.data != null) {
        final technicians = result.data!['getAvailableTechnicians'] as List;
        setState(() {
          _technicians =
              technicians.map((json) => Technician.fromJson(json)).toList();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load technicians: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingTechnicians = false);
      }
    }
  }

  String _handleGraphQLError(OperationException? exception) {
    if (exception == null) return 'Unknown error occurred';
    if (exception.linkException != null) {
      return 'Network error occurred. Please check your connection.';
    }
    if (exception.graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors.map((e) => e.message).join(', ');
    }
    return 'An error occurred while loading technicians';
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedTechnician == null)
      return;

    setState(() => _isSubmitting = true);

    try {
      final userId = await AuthService.getUserId();
      if (userId == null) throw Exception('User not authenticated');

      await ref
          .read(serviceRequestNotifierProvider.notifier)
          .createServiceRequest(
            title: _selectedService!,
            description: _descriptionController.text.trim(),
            clientId: userId,
            technicianId: _selectedTechnician!.id ?? '',
          );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to create request: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Request for Service',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: _inputDecoration('Select Service'),
                dropdownColor: Colors.white,
                style: TextStyle(fontSize: 16, color: Colors.black87),
                items: _serviceOptions.map((service) {
                  return DropdownMenuItem(
                    value: service,
                    child: Text(service,
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedService = value),
                validator: (value) =>
                    value == null ? 'Please select a service' : null,
              ),
              const SizedBox(height: 16),
              if (_isLoadingTechnicians)
                const CircularProgressIndicator()
              else if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(
                      color: colorScheme.error, fontWeight: FontWeight.w500),
                )
              else if (_technicians.isEmpty)
                const Text(
                  'No available technicians found',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey),
                )
              else
                DropdownButtonFormField<Technician>(
                  value: _selectedTechnician,
                  decoration: _inputDecoration('Select Technician'),
                  dropdownColor: Colors.white,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  items: _technicians.map((tech) {
                    return DropdownMenuItem(
                      value: tech,
                      child: Text(tech.fullName,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedTechnician = value),
                  validator: (value) =>
                      value == null ? 'Please select a technician' : null,
                  isExpanded: true,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Description').copyWith(
                  hintText: 'Describe your service request...',
                  hintStyle: const TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey),
                ),
                maxLines: 3,
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Please enter a description';
                  if (value.length > 500)
                    return 'Description too long (max 500 characters)';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed:
              _isSubmitting || _isLoadingTechnicians ? null : _submitForm,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }
}
