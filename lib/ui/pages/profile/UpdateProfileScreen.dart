import 'package:firetrack360/graphql/mutations/profile_mutations.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Map<String, dynamic> currentProfile;

  const UpdateProfileScreen({
    Key? key,
    required this.currentProfile,
  }) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _bioController;
  bool _isLoading = false;

  // Store original values for comparison
  late final Map<String, String> _originalValues;
  final Map<String, bool> _modifiedFields = {};

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current values
    _firstNameController =
        TextEditingController(text: widget.currentProfile['firstName'] ?? '');
    _lastNameController =
        TextEditingController(text: widget.currentProfile['lastName'] ?? '');
    _addressController =
        TextEditingController(text: widget.currentProfile['address'] ?? '');
    _cityController =
        TextEditingController(text: widget.currentProfile['city'] ?? '');
    _stateController =
        TextEditingController(text: widget.currentProfile['state'] ?? '');
    _zipCodeController =
        TextEditingController(text: widget.currentProfile['zipCode'] ?? '');
    _bioController =
        TextEditingController(text: widget.currentProfile['bio'] ?? '');

    // Store original values
    _originalValues = {
      'firstName': widget.currentProfile['firstName'] ?? '',
      'lastName': widget.currentProfile['lastName'] ?? '',
      'address': widget.currentProfile['address'] ?? '',
      'city': widget.currentProfile['city'] ?? '',
      'state': widget.currentProfile['state'] ?? '',
      'zipCode': widget.currentProfile['zipCode'] ?? '',
      'bio': widget.currentProfile['bio'] ?? '',
    };

    // Add listeners to track changes
    _firstNameController
        .addListener(() => _onFieldChanged('firstName', _firstNameController));
    _lastNameController
        .addListener(() => _onFieldChanged('lastName', _lastNameController));
    _addressController
        .addListener(() => _onFieldChanged('address', _addressController));
    _cityController.addListener(() => _onFieldChanged('city', _cityController));
    _stateController
        .addListener(() => _onFieldChanged('state', _stateController));
    _zipCodeController
        .addListener(() => _onFieldChanged('zipCode', _zipCodeController));
    _bioController.addListener(() => _onFieldChanged('bio', _bioController));
  }

  void _onFieldChanged(String fieldName, TextEditingController controller) {
    final newValue = controller.text;
    final originalValue = _originalValues[fieldName] ?? '';

    if (newValue != originalValue) {
      setState(() {
        _modifiedFields[fieldName] = true;
      });
    } else {
      setState(() {
        _modifiedFields.remove(fieldName);
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String? _validateField(String? value, String fieldName) {
    if (!_modifiedFields.containsKey(fieldName)) return null;

    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }

    if (fieldName == 'zipCode') {
      if (!RegExp(r'^\d{5}(-\d{4})?$').hasMatch(value)) {
        return 'Please enter a valid ZIP code';
      }
    }
    return null;
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (_modifiedFields.isEmpty) {
      _showErrorSnackBar('No changes made');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final client = GraphQLProvider.of(context).value;

      final Map<String, dynamic> updateInput = {};
      _modifiedFields.forEach((field, _) {
        switch (field) {
          case 'firstName':
            updateInput['firstName'] = _firstNameController.text;
            break;
          case 'lastName':
            updateInput['lastName'] = _lastNameController.text;
            break;
          case 'address':
            updateInput['address'] = _addressController.text;
            break;
          case 'city':
            updateInput['city'] = _cityController.text;
            break;
          case 'state':
            updateInput['state'] = _stateController.text;
            break;
          case 'zipCode':
            updateInput['zipCode'] = _zipCodeController.text;
            break;
          case 'bio':
            updateInput['bio'] = _bioController.text;
            break;
        }
      });

      final MutationOptions options = MutationOptions(
        document: gql(updateProfileMutation),
        variables: {
          'id': widget.currentProfile['id'],
          'profileInput': updateInput,
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        if (mounted) {
          _showErrorSnackBar(result.exception.toString());
        }
        return;
      }

      final responseData = result.data?['updateProfile'];
      if (responseData?['status'] == 200) {
        if (mounted) {
          // Update original values after successful submission
          _modifiedFields.forEach((field, _) {
            _originalValues[field] = updateInput[field];
          });
          _modifiedFields.clear();

          _showSuccessSnackBar(
              responseData['message'] ?? 'Profile updated successfully');
          Navigator.pop(context, true);
        }
      } else {
        throw Exception(responseData?['message'] ?? 'Update failed');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    bool alignLabelWithHint = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        alignLabelWithHint: alignLabelWithHint,
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed:
                  _modifiedFields.isEmpty ? null : () => _handleSubmit(context),
              tooltip: 'Save Changes',
            ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSection(
                title: 'Personal Information',
                children: [
                  _buildTextField(
                    controller: _firstNameController,
                    labelText: 'First Name',
                    icon: Icons.person_outline,
                    validator: (value) => _validateField(value, 'firstName'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _lastNameController,
                    labelText: 'Last Name',
                    icon: Icons.person_outline,
                    validator: (value) => _validateField(value, 'lastName'),
                  ),
                ],
              ),
              _buildSection(
                title: 'Address',
                children: [
                  _buildTextField(
                    controller: _addressController,
                    labelText: 'Street Address',
                    icon: Icons.location_on,
                    validator: (value) => _validateField(value, 'address'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _cityController,
                    labelText: 'City',
                    icon: Icons.location_city,
                    validator: (value) => _validateField(value, 'city'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _stateController,
                          labelText: 'State',
                          icon: Icons.map,
                          validator: (value) => _validateField(value, 'state'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _zipCodeController,
                          labelText: 'ZIP Code',
                          icon: Icons.pin,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              _validateField(value, 'zipCode'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _buildSection(
                title: 'About',
                children: [
                  _buildTextField(
                    controller: _bioController,
                    labelText: 'Bio',
                    icon: Icons.edit,
                    maxLines: 3,
                    maxLength: 500,
                    alignLabelWithHint: true,
                    validator: (value) => _validateField(value, 'bio'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading || _modifiedFields.isEmpty
                    ? null
                    : () => _handleSubmit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'SAVE CHANGES',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
