// user_table.dart
import 'package:flutter/material.dart';
import 'package:firetrack360/models/users.dart';
import 'package:firetrack360/generated/l10n.dart';

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
    _applySorting();
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

  int get _pageCount {
    if (_sortedUsers.isEmpty) return 1;
    return (_sortedUsers.length / _rowsPerPage).ceil();
  }

  void _showUserDetails(User user) {
    final l10n = S.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: theme.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildUserDetailHeader(user, l10n),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow(l10n.emailLabel, user.email, Icons.email),
                    _buildDetailRow(l10n.phoneLabel,
                        user.phone ?? l10n.notAvailable, Icons.phone),
                    _buildDetailRow(l10n.roleLabel, user.role, Icons.badge),
                    _buildDetailRow(
                        l10n.statusLabel,
                        user.verified
                            ? l10n.statusVerified
                            : l10n.statusUnverified,
                        user.verified ? Icons.verified : Icons.pending),
                    if (user.city != null || user.state != null)
                      _buildDetailRow(
                          l10n.locationLabel,
                          '${user.city ?? ''}, ${user.state ?? ''}'.trim(),
                          Icons.location_on),
                  ],
                ),
              ),
              Divider(height: 1, color: theme.dividerColor),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        l10n.closeButton,
                        style: TextStyle(
                          color: theme.primaryColor,
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

  Widget _buildUserDetailHeader(User user, S l10n) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.onPrimary,
            child: Icon(
              Icons.person,
              color: theme.primaryColor,
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
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.role,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary.withOpacity(0.8),
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
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyLarge?.color,
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
    final l10n = S.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Theme(
                  data: theme.copyWith(
                    dataTableTheme: DataTableThemeData(
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => theme.primaryColor.withOpacity(0.05),
                      ),
                      dataTextStyle: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      headingTextStyle: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  child: DataTable(
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: [
                      DataColumn(
                        label: Text(
                          l10n.columnEmail,
                          style: TextStyle(
                            color: theme.primaryColor,
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
                          l10n.columnPhone,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onSort: (columnIndex, ascending) {
                          _sort<String>((user) => user.phone ?? '', columnIndex,
                              ascending);
                        },
                      ),
                      DataColumn(
                        label: Text(
                          l10n.columnRole,
                          style: TextStyle(
                            color: theme.primaryColor,
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
                          l10n.columnStatus,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onSort: (columnIndex, ascending) {
                          _sort<num>((user) => user.verified ? 1 : 0,
                              columnIndex, ascending);
                        },
                      ),
                      DataColumn(
                        label: Text(
                          l10n.columnActions,
                          style: TextStyle(
                            color: theme.primaryColor,
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
                                        backgroundColor:
                                            theme.primaryColor.withOpacity(0.1),
                                        child: Icon(
                                          Icons.person,
                                          size: 16,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        user.email,
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodyMedium?.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    user.phone ?? l10n.notAvailable,
                                    style: TextStyle(
                                      color: theme.textTheme.bodyMedium?.color,
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
                                      color:
                                          theme.primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      user.role,
                                      style: TextStyle(
                                        color: theme.primaryColor,
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
                                              ? l10n.statusVerified
                                              : l10n.statusUnverified,
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
                                          color: theme.primaryColor,
                                        ),
                                        onPressed: () => _showUserDetails(user),
                                        tooltip: l10n.viewDetailsTooltip,
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
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.rowsPerPageLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _rowsPerPage,
                      dropdownColor: theme.cardColor,
                      items: [10, 20, 50].map((value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
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
                      l10n.showingRecords(
                        _sortedUsers.isEmpty
                            ? 0
                            : _currentPage * _rowsPerPage + 1,
                        (_currentPage + 1) * _rowsPerPage > _sortedUsers.length
                            ? _sortedUsers.length
                            : (_currentPage + 1) * _rowsPerPage,
                        _sortedUsers.length,
                        _rowsPerPage,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: _currentPage > 0
                            ? theme.primaryColor
                            : theme.disabledColor,
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
                            ? theme.primaryColor
                            : theme.disabledColor,
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
