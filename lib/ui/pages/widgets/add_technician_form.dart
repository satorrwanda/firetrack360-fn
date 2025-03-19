import 'package:flutter/material.dart';
import 'package:firetrack360/models/technician.dart';

Widget _buildTechnicianDetailHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFA65D57), // Matching button color
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person_add,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Technician',
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

// Function to show the Add Technician modal dialog with form
void showAddTechnicianModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const AddTechnicianDialog(),
      );
    },
  );
}

class AddTechnicianDialog extends StatelessWidget {
  const AddTechnicianDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTechnicianDetailHeader(context),
            const SizedBox(height: 24),
            const AddTechnicianFormNoSubmit(),
          ],
        ),
      ),
    );
  }
}

// Modified form that doesn't submit to API
class AddTechnicianFormNoSubmit extends StatefulWidget {
  const AddTechnicianFormNoSubmit({super.key});

  @override
  _AddTechnicianFormNoSubmitState createState() =>
      _AddTechnicianFormNoSubmitState();
}

class _AddTechnicianFormNoSubmitState extends State<AddTechnicianFormNoSubmit> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController(text: 'Technician');

  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _handleFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 1));

      // Create technician object but don't submit to API
      final technician = Technician(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        role: _roleController.text,
      );

      debugPrint('Technician data (not submitted): $technician');

      // Close the dialog
      if (mounted) {
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Technician added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
              if (value == null || value.isEmpty)
                return 'Please enter an email';
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
          const SizedBox(height: 16),
          TextFormField(
            controller: _roleController,
            decoration: _inputDecoration('Role', Icons.work),
            readOnly: true, // Make this field read-only since it's fixed
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isSubmitting ? null : () => Navigator.pop(context),
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
