import 'package:flutter/material.dart';
import 'package:firetrack360/providers/users_provider.dart';

class AddTechnicianDialog extends StatelessWidget {
  final UsersProvider usersProvider;

  const AddTechnicianDialog({super.key, required this.usersProvider});

  @override
  Widget build(BuildContext context) {
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
              _buildTechnicianDetailHeader(context),
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

  Widget _buildTechnicianDetailHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFA65D57),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person_add,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Technician',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
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

  void _handleFormSubmit() async {
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
            throw Exception('Request timed out');
          },
        );

        widget.usersProvider.refreshUsers();

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  response['message'] ?? 'Technician created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: _inputDecoration('First Name', Icons.person),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a first name'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: _inputDecoration('Last Name', Icons.person_outline),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a last name'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration('Email', Icons.email),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!value.contains('@')) return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: _inputDecoration('Phone', Icons.phone),
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a phone number'
                  : null,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      _isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _handleFormSubmit,
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
                  label: Text(_isSubmitting ? 'Creating...' : 'Create'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA65D57),
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
