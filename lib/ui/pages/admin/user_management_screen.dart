import 'package:firetrack360/ui/pages/widgets/add_technician_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firetrack360/models/users.dart';
import 'package:firetrack360/providers/users_provider.dart';
import 'package:firetrack360/ui/pages/widgets/user_table.dart';
import 'package:firetrack360/generated/l10n.dart';
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
            user.firstName!.toLowerCase().contains(query) ||
            user.lastName!.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query) ||
            user.role.toLowerCase().contains(query))
        .toList();
  }

  // Function to show the Add Technician modal dialog
  void showAddTechnicianModal(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final l10n = S.of(context)!; // Get localized strings

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Assuming AddTechnicianDialog might need l10n too, pass it if necessary
        return AddTechnicianDialog(usersProvider: usersProvider);
      },
    );
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

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!; // Get localized strings

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  // Localized title
                  l10n.userManagementTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    context.read<UsersProvider>().refreshUsers();
                    // Localized success message for refresh
                    _showSuccessSnackBar(l10n.userListRefreshed);
                  },
                  tooltip: l10n.refreshTooltip, // Localized tooltip
                ),
                IconButton(
                  icon: const Icon(Icons.person_add, color: Colors.white),
                  onPressed: () => showAddTechnicianModal(context),
                  tooltip: l10n.addUserTooltip, // Localized tooltip
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
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        hintText: l10n.searchUsersHint, // Localized hint text
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.deepPurple),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Consumer<UsersProvider>(
                          builder: (context, provider, child) {
                            if (provider.isLoading) {
                              return Center(
                                // Localized loading text (optional, can keep indicator only)
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          Colors.deepPurple),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(l10n.loadingMessage),
                                  ],
                                ),
                              );
                            }

                            if (provider.error != null) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors
                                            .red, // Consistent with snackbar error
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        // Localized error message header
                                        l10n.errorLoadingUsers,
                                        style: const TextStyle(
                                            color: Colors.deepPurple),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        // Display the actual error message
                                        provider.error!,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () =>
                                            provider.refreshUsers(),
                                        child: Text(
                                          // Localized retry button
                                          l10n.retryButton,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final filteredUsers =
                                _getFilteredUsers(provider.users);

                            if (filteredUsers.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      // Localized empty state message
                                      _searchQuery.isEmpty
                                          ? l10n.noUsersFound
                                          : l10n.noUsersMatchSearch,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (_searchQuery.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        l10n.adjustSearchOrFilters,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }
                            return UserTable(users: filteredUsers);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () => showAddTechnicianModal(context),
        tooltip: l10n.addUserTooltip, // Localized tooltip
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
