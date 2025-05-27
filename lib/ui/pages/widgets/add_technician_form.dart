import 'package:flutter/material.dart';
import 'package:firetrack360/providers/users_provider.dart';
import 'package:firetrack360/generated/l10n.dart';

class AddTechnicianDialog extends StatelessWidget {
  final UsersProvider usersProvider;

  const AddTechnicianDialog({super.key, required this.usersProvider});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTechnicianDetailHeader(context, l10n),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AddTechnicianForm(usersProvider: usersProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicianDetailHeader(BuildContext context, S l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person_add,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.addTechnician_dialogTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddTechnicianForm extends StatefulWidget {
  final UsersProvider usersProvider;

  const AddTechnicianForm({super.key, required this.usersProvider});

  @override
  _AddTechnicianFormState createState() => _AddTechnicianFormState();
}

class _AddTechnicianFormState extends State<AddTechnicianForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleFormSubmit(BuildContext context) async {
    final l10n = S.of(context)!;

    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      print('Form is valid. Preparing payload...');

      final input = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
      };

      try {
        final response =
            await widget.usersProvider.createTechnician(input).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception(l10n.error_requestTimedOut);
          },
        );

        widget.usersProvider.refreshUsers();

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ??
                  l10n.snackbar_technicianCreatedSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.error_prefix}: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    } else {
      print('Form validation failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration:
                  _inputDecoration(l10n.textField_firstName, Icons.person),
              validator: (value) => value == null || value.isEmpty
                  ? l10n.validation_firstNameRequired
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: _inputDecoration(
                  l10n.textField_lastName, Icons.person_outline),
              validator: (value) => value == null || value.isEmpty
                  ? l10n.validation_lastNameRequired
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration(l10n.textField_email, Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.validation_emailRequired;
                }
                if (!value.contains('@')) return l10n.validation_emailValid;
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: _inputDecoration(l10n.textField_phone, Icons.phone),
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.isEmpty
                  ? l10n.validation_phoneRequired
                  : null,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _isSubmitting ? null : () => Navigator.pop(context),
                  child: Text(l10n.button_cancel),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed:
                      _isSubmitting ? null : () => _handleFormSubmit(context),
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add),
                  label: Text(_isSubmitting
                      ? l10n.button_creating
                      : l10n.button_create),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      prefixIcon: Icon(icon),
    );
  }
}
