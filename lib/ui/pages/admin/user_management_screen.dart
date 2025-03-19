// lib/ui/pages/user_management_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firetrack360/models/users.dart';
import 'package:firetrack360/providers/users_provider.dart';
import 'package:firetrack360/ui/pages/widgets/user_table.dart';
import 'package:firetrack360/ui/pages/widgets/add_technician_form.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsersProvider(),
      child: const _UserManagementContent(),
    );
  }
}

class _UserManagementContent extends StatefulWidget {
  const _UserManagementContent();

  @override
  State<_UserManagementContent> createState() => _UserManagementContentState();
}

class _UserManagementContentState extends State<_UserManagementContent> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<UsersProvider>().loadUsers();
      }
    });
  }

  List<User> _getFilteredUsers(List<User> users) {
    if (_searchQuery.isEmpty) return users;

    final query = _searchQuery.toLowerCase();
    return users
        .where((user) =>
            user.firstName.toLowerCase().contains(query) ||
            user.lastName.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query) ||
            user.role.toLowerCase().contains(query))
        .toList();
  }

  // Function to show the Add Technician modal dialog
  void showAddTechnicianModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add New Technician',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const AddTechnicianFormNoSubmit(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFA65D57),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'User Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => context.read<UsersProvider>().refreshUsers(),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add, color: Colors.white),
                  onPressed: () => showAddTechnicianModal(context),
                ),
              ],
            ),
          ),
          // Body content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search users...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                    ),
                  ),
                  // Table
                  Expanded(
                    child: Consumer<UsersProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Color(0xFFA65D57)),
                            ),
                          );
                        }

                        if (provider.error != null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  provider.error!,
                                  style:
                                      const TextStyle(color: Color(0xFFA65D57)),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFA65D57),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => provider.refreshUsers(),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        final filteredUsers = _getFilteredUsers(provider.users);
                        return UserTable(users: filteredUsers);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleFormSubmit() {
    if (_formKey.currentState!.validate()) {
      // Just close the dialog without submitting to API
      Navigator.pop(context);

      // Optionally show a message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Form validated but not submitted to API')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a first name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a last name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleFormSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA65D57),
                foregroundColor: Colors.white,
              ),
              child: const Text('Create Technician'),
            ),
          ],
        ),
      ),
    );
  }
}
