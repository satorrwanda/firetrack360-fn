// user_table.dart
import 'package:flutter/material.dart';
import 'package:firetrack360/models/users.dart';

class UserTable extends StatefulWidget {
  final List<User> users;

  const UserTable({
    super.key,
    this.users = const [],
  });

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  int _rowsPerPage = 10;
  int _currentPage = 0;
  int? _sortColumnIndex;
  bool _sortAscending = true;
  List<User> _sortedUsers = [];

  @override
  void initState() {
    super.initState();
    _sortedUsers = List.from(widget.users);
  }

  @override
  void didUpdateWidget(UserTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.users != oldWidget.users) {
      _sortedUsers = List.from(widget.users);
      _applySorting();
    }
  }

  void _sort<T>(Comparable<T> Function(User user) getField, int columnIndex,
      bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _sortedUsers.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  void _applySorting() {
    if (_sortColumnIndex != null) {
      switch (_sortColumnIndex) {
        case 0:
          _sort((user) => user.email, 0, _sortAscending);
          break;
        case 1:
          _sort((user) => user.phone ?? '', 1, _sortAscending);
          break;
        case 2:
          _sort((user) => user.role, 2, _sortAscending);
          break;
        case 3:
          _sort((user) => user.verified ? 1 : 0, 3, _sortAscending);
          break;
      }
    }
  }

  List<User> get _paginatedUsers {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    if (startIndex >= _sortedUsers.length) return [];
    return _sortedUsers.sublist(
      startIndex,
      endIndex > _sortedUsers.length ? _sortedUsers.length : endIndex,
    );
  }

  int get _pageCount => (_sortedUsers.length / _rowsPerPage).ceil();

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildUserDetailHeader(user),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow('Email', user.email, Icons.email),
                    _buildDetailRow('Phone', user.phone ?? '-', Icons.phone),
                    _buildDetailRow('Role', user.role, Icons.badge),
                    _buildDetailRow(
                        'Status',
                        user.verified ? 'Verified' : 'Unverified',
                        user.verified ? Icons.verified : Icons.pending),
                    if (user.city != null || user.state != null)
                      _buildDetailRow(
                          'Location',
                          '${user.city ?? ''}, ${user.state ?? ''}'.trim(),
                          Icons.location_on),
                  ],
                ),
              ),
              const Divider(height: 1),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.deepPurple, // Primary color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetailHeader(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple, // Primary color
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Colors.deepPurple, // Primary color
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.role,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple), // Primary color
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600, // Consistent with login form
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87, // Consistent with login form
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) =>
                        Colors.deepPurple.withOpacity(0.05), // Light tint
                  ),
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.deepPurple, // Primary color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        _sort<String>(
                            (user) => user.email, columnIndex, ascending);
                      },
                    ),
                    DataColumn(
                      label: Text(
                        'Phone',
                        style: TextStyle(
                          color: Colors.deepPurple, // Primary color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        _sort<String>(
                            (user) => user.phone ?? '', columnIndex, ascending);
                      },
                    ),
                    DataColumn(
                      label: Text(
                        'Role',
                        style: TextStyle(
                          color: Colors.deepPurple, // Primary color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        _sort<String>(
                            (user) => user.role, columnIndex, ascending);
                      },
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          color: Colors.deepPurple, // Primary color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onSort: (columnIndex, ascending) {
                        _sort<num>((user) => user.verified ? 1 : 0, columnIndex,
                            ascending);
                      },
                    ),
                    DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(
                          color: Colors.deepPurple, // Primary color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows: _paginatedUsers
                      .map((user) => DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.deepPurple
                                          .withOpacity(0.1), // Light tint
                                      child: Icon(
                                        Icons.person,
                                        size: 16,
                                        color:
                                            Colors.deepPurple, // Primary color
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      user.email,
                                      style: const TextStyle(
                                        color:
                                            Colors.black87, // Consistent text
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Text(
                                  user.phone ?? '-',
                                  style: const TextStyle(
                                    color: Colors.black87, // Consistent text
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple
                                        .withOpacity(0.1), // Light tint
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    user.role,
                                    style: TextStyle(
                                      color: Colors.deepPurple, // Primary color
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
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
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        user.verified
                                            ? Icons.check_circle
                                            : Icons.pending,
                                        size: 14,
                                        color: user.verified
                                            ? Colors.green
                                            : Colors.orange,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        user.verified
                                            ? 'Verified'
                                            : 'Unverified',
                                        style: TextStyle(
                                          color: user.verified
                                              ? Colors.green
                                              : Colors.orange,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.visibility_outlined,
                                        color:
                                            Colors.deepPurple, // Primary color
                                      ),
                                      onPressed: () => _showUserDetails(user),
                                      tooltip: 'View Details',
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit_outlined,
                                        color:
                                            Colors.deepPurple, // Primary color
                                      ),
                                      onPressed: () {
                                        // TODO: Implement edit functionality
                                      },
                                      tooltip: 'Edit User',
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Rows per page:',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _rowsPerPage,
                      items: [10, 20, 50].map((value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
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
                    const SizedBox(width: 24),
                    Text(
                      '${_sortedUsers.isEmpty ? 0 : _currentPage * _rowsPerPage + 1}-${(_currentPage + 1) * _rowsPerPage > _sortedUsers.length ? _sortedUsers.length : (_currentPage + 1) * _rowsPerPage} of ${_sortedUsers.length}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: _currentPage > 0
                            ? Colors.deepPurple // Primary color
                            : Colors.grey,
                      ),
                      onPressed: _currentPage > 0
                          ? () {
                              setState(() {
                                _currentPage--;
                              });
                            }
                          : null,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: _currentPage < _pageCount - 1
                            ? Colors.deepPurple // Primary color
                            : Colors.grey,
                      ),
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
