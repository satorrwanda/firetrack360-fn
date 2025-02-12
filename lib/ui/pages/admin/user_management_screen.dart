// user_management_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firetrack360/providers/users_provider.dart';
import 'package:firetrack360/models/users.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _searchQuery = '';
  String _currentFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Users Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              context.read<UsersProvider>().refreshUsers();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add New User',
            onPressed: () {
              // TODO: Implement add new user functionality
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => UsersProvider(),
        child: _UserManagementBody(
          searchQuery: _searchQuery,
          currentFilter: _currentFilter,
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          onFilterChanged: (value) {
            setState(() {
              _currentFilter = value;
            });
          },
        ),
      ),
    );
  }
}

class _UserManagementBody extends StatefulWidget {
  final String searchQuery;
  final String currentFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterChanged;

  const _UserManagementBody({
    required this.searchQuery,
    required this.currentFilter,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  @override
  State<_UserManagementBody> createState() => _UserManagementBodyState();
}

class _UserManagementBodyState extends State<_UserManagementBody> {
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
    var filteredUsers = users;

    if (widget.searchQuery.isNotEmpty) {
      final lowercaseQuery = widget.searchQuery.toLowerCase();
      filteredUsers = filteredUsers
          .where((user) =>
              user.firstName.toLowerCase().contains(lowercaseQuery) ||
              user.lastName.toLowerCase().contains(lowercaseQuery) ||
              user.email.toLowerCase().contains(lowercaseQuery) ||
              (user.phone?.toLowerCase().contains(lowercaseQuery) ?? false) ||
              user.role.toLowerCase().contains(lowercaseQuery) ||
              (user.city?.toLowerCase().contains(lowercaseQuery) ?? false) ||
              (user.state?.toLowerCase().contains(lowercaseQuery) ?? false))
          .toList();
    }

    switch (widget.currentFilter) {
      case 'verified':
        filteredUsers = filteredUsers.where((user) => user.verified).toList();
        break;
      case 'unverified':
        filteredUsers = filteredUsers.where((user) => !user.verified).toList();
        break;
      case 'active':
        filteredUsers = filteredUsers.where((user) => user.isActive).toList();
        break;
      case 'inactive':
        filteredUsers = filteredUsers.where((user) => !user.isActive).toList();
        break;
      case 'admin':
        filteredUsers = filteredUsers
            .where((user) => user.role.toLowerCase() == 'admin')
            .toList();
        break;
    }

    return filteredUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading users...'),
              ],
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
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadUsers(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final filteredUsers = _getFilteredUsers(provider.users);
        return UserManagementContent(
          users: filteredUsers,
          onSearchChanged: widget.onSearchChanged,
          currentFilter: widget.currentFilter,
          onFilterChanged: widget.onFilterChanged,
        );
      },
    );
  }
}

class UserManagementContent extends StatelessWidget {
  final List<User> users;
  final ValueChanged<String> onSearchChanged;
  final String currentFilter;
  final ValueChanged<String> onFilterChanged;

  const UserManagementContent({
    super.key,
    required this.users,
    required this.onSearchChanged,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: UserTable(users: users),
            ),
          ],
        ),
      ),
    );
  }
}

class UserTable extends StatefulWidget {
  final List<User> users;

  const UserTable({
    super.key,
    required this.users,
  });

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  int _rowsPerPage = 10;
  int _currentPage = 0;

  List<User> get _paginatedUsers {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    if (startIndex >= widget.users.length) return [];
    return widget.users.sublist(
      startIndex,
      endIndex > widget.users.length ? widget.users.length : endIndex,
    );
  }

  int get _pageCount => (widget.users.length / _rowsPerPage).ceil();

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.email),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Email', user.email),
              _detailRow('Phone', user.phone ?? '-'),
              _detailRow('Role', user.role),
              _detailRow('Status', user.verified ? 'Verified' : 'Unverified'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Phone')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('')), // Actions column
                  ],
                  rows: _paginatedUsers
                      .map((user) => DataRow(
                            cells: [
                              DataCell(Text(user.email)),
                              DataCell(Text(user.phone ?? '-')),
                              DataCell(Text(user.role)),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: user.verified
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user.verified ? 'Verified' : 'Unverified',
                                    style: TextStyle(
                                      color: user.verified
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                PopupMenuButton(
                                  icon: const Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () => _showUserDetails(user),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.visibility),
                                          SizedBox(width: 8),
                                          Text('View Details'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Rows per page:'),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _rowsPerPage,
                      items: [10, 20, 50].map((value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _rowsPerPage = value;
                            _currentPage = 0;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _currentPage > 0
                          ? () {
                              setState(() {
                                _currentPage--;
                              });
                            }
                          : null,
                    ),
                    Text('${_currentPage + 1} of $_pageCount'),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _currentPage < _pageCount - 1
                          ? () {
                              setState(() {
                                _currentPage++;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
