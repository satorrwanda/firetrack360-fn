import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:firetrack360/configs/graphql_client.dart';
import 'package:firetrack360/graphql/queries/profile_query.dart';
import 'package:firetrack360/models/technician.dart';
import 'package:firetrack360/services/auth_service.dart';
import 'package:firetrack360/providers/ServiceRequestProvider.dart';
import 'package:firetrack360/generated/l10n.dart';

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
    'refillService',
    'maintenanceService',
    'supplyService',
    'otherServices'
  ];
  String? _selectedServiceKey;
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
    final l10n = S.of(context)!;

    if (exception == null) return l10n.unknownErrorOccurred;
    if (exception.linkException != null) {
      return l10n.networkErrorOccurred;
    }
    if (exception.graphqlErrors.isNotEmpty) {
      return exception.graphqlErrors.map((e) => e.message).join(', ');
    }
    return l10n.errorLoadingTechnicians;
  }

  Future<void> _submitForm() async {
    final l10n = S.of(context)!;

    if (!_formKey.currentState!.validate() ||
        _selectedTechnician == null ||
        _selectedServiceKey == null) return;

    setState(() => _isSubmitting = true);

    try {
      final userId = await AuthService.getUserId();
      if (userId == null) throw Exception(l10n.userNotAuthenticated);

      final serviceTitle = _localizeService(_selectedServiceKey!, l10n);

      await ref
          .read(serviceRequestNotifierProvider.notifier)
          .createServiceRequest(
            title: serviceTitle,
            description: _descriptionController.text.trim(),
            clientId: userId,
            technicianId: _selectedTechnician!.id ?? '',
          );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = l10n.failedToCreateRequest(e.toString(), '');
        });
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _inputDecoration(
      String labelTextKey, ColorScheme colorScheme) {
    final l10n = S.of(context)!;
    String labelText;
    switch (labelTextKey) {
      case 'selectServiceLabel':
        labelText = l10n.selectServiceLabel;
        break;
      case 'selectTechnicianLabel':
        labelText = l10n.selectTechnicianLabel;
        break;
      case 'descriptionLabel':
        labelText = l10n.descriptionLabel;
        break;
      default:
        labelText = '';
    }
    return InputDecoration(
      labelText: labelText,
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
        borderSide: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.4), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
    );
  }

  String _localizeService(String serviceKey, S l10n) {
    switch (serviceKey) {
      case 'refillService':
        return l10n.refillService;
      case 'maintenanceService':
        return l10n.maintenanceService;
      case 'supplyService':
        return l10n.supplyService;
      case 'otherServices':
        return l10n.otherServices;
      default:
        return serviceKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final l10n = S.of(context)!;

    final dialogBackgroundColor =
        isDarkMode ? Colors.deepPurple.shade800 : Colors.white;
    final dialogTextColor = isDarkMode ? Colors.white : Colors.black87;
    final dialogSecondaryTextColor =
        isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final dialogPrimaryColor = colorScheme.primary;

    return AlertDialog(
      backgroundColor: dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        l10n.requestForServiceTitle,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: dialogPrimaryColor,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedServiceKey,
                decoration: _inputDecoration('selectServiceLabel', colorScheme),
                dropdownColor: dialogBackgroundColor,
                style: TextStyle(fontSize: 16, color: dialogTextColor),
                items: _serviceOptions.map((serviceKey) {
                  return DropdownMenuItem(
                    value: serviceKey,
                    child: Text(_localizeService(serviceKey, l10n),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: dialogTextColor)),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedServiceKey = value),
                validator: (value) =>
                    value == null ? l10n.pleaseSelectService : null,
                iconEnabledColor: dialogPrimaryColor,
                iconDisabledColor: dialogSecondaryTextColor,
              ),
              const SizedBox(height: 16),
              if (_isLoadingTechnicians)
                Center(
                    child: CircularProgressIndicator(color: dialogPrimaryColor))
              else if (_errorMessage != null && !_isSubmitting)
                Text(
                  _errorMessage!,
                  style: TextStyle(
                      color: colorScheme.error, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )
              else if (_technicians.isEmpty)
                Text(
                  l10n.noAvailableTechniciansFound,
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: dialogSecondaryTextColor),
                  textAlign: TextAlign.center,
                )
              else
                DropdownButtonFormField<Technician>(
                  value: _selectedTechnician,
                  decoration:
                      _inputDecoration('selectTechnicianLabel', colorScheme),
                  dropdownColor: dialogBackgroundColor,
                  style: TextStyle(fontSize: 16, color: dialogTextColor),
                  items: _technicians.map((tech) {
                    return DropdownMenuItem(
                      value: tech,
                      child: Text(tech.fullName,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: dialogTextColor)),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedTechnician = value),
                  validator: (value) =>
                      value == null ? l10n.pleaseSelectTechnician : null,
                  isExpanded: true,
                  iconEnabledColor: dialogPrimaryColor,
                  iconDisabledColor: dialogSecondaryTextColor,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    _inputDecoration('descriptionLabel', colorScheme).copyWith(
                  hintText: l10n.describeServiceRequestHint,
                  hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: dialogSecondaryTextColor),
                  fillColor: dialogBackgroundColor,
                  filled: true,
                ),
                maxLines: 3,
                style: TextStyle(fontSize: 16, color: dialogTextColor),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return l10n.pleaseEnterDescription;
                  if (value.length > 500) return l10n.descriptionTooLong;
                  return null;
                },
              ),
              if (_errorMessage != null &&
                  !_isLoadingTechnicians &&
                  !_isSubmitting)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                        color: colorScheme.error, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: dialogPrimaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: Text(l10n.cancelButton,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: dialogPrimaryColor,
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
              : Text(l10n.submitButton,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary)),
        ),
      ],
    );
  }
}
