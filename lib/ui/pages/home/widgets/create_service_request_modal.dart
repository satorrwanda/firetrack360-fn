import 'package:firetrack360/configs/graphql_client.dart';
import 'package:firetrack360/graphql/queries/profile_query.dart';
import 'package:firetrack360/models/technician.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTechnician == null) return;

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

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        print(e.toString());
        setState(() {
          _errorMessage = 'Failed to create request: ${e.toString()}';
        });
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        'Create New Service Request',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Service Dropdown with Enhanced Styling
              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: InputDecoration(
                  labelText: 'Select Service',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                dropdownColor: Colors.white,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 16,
                ),
                items: _serviceOptions.map((service) {
                  return DropdownMenuItem(
                    value: service,
                    child: Text(
                      service,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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

              // Technician Dropdown with Elegant Styling
              if (_isLoadingTechnicians)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (_technicians.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'No available technicians found',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                DropdownButtonFormField<Technician>(
                  value: _selectedTechnician,
                  decoration: InputDecoration(
                    labelText: 'Select Technician',
                    labelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 16,
                  ),
                  items: _technicians.map((technician) {
                    return DropdownMenuItem(
                      value: technician,
                      child: Text(
                        technician.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                  isExpanded: true,
                ),
              const SizedBox(height: 16),

              // Description TextField with Modern Styling
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  hintText: 'Describe your service request...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 16,
                ),
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
        // Styled Action Buttons
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed:
              _isSubmitting || _isLoadingTechnicians ? null : _submitForm,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }
}
