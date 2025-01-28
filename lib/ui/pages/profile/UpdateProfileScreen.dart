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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes made')),
      );
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
          _showErrorDialog(context, result.exception.toString());
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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  responseData['message'] ?? 'Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        throw Exception(responseData?['message'] ?? 'Update failed');
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSection(
              title: 'Personal Information',
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => _validateField(value, 'firstName'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => _validateField(value, 'lastName'),
                ),
              ],
            ),
            _buildSection(
              title: 'Address',
              children: [
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Street Address',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) => _validateField(value, 'address'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator: (value) => _validateField(value, 'city'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: const InputDecoration(
                          labelText: 'State',
                          prefixIcon: Icon(Icons.map),
                        ),
                        validator: (value) => _validateField(value, 'state'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _zipCodeController,
                        decoration: const InputDecoration(
                          labelText: 'ZIP Code',
                          prefixIcon: Icon(Icons.pin),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => _validateField(value, 'zipCode'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            _buildSection(
              title: 'About',
              children: [
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    prefixIcon: Icon(Icons.edit),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  maxLength: 500,
                  validator: (value) => _validateField(value, 'bio'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }
}
