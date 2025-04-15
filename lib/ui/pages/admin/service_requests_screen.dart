import 'package:firetrack360/hooks/use_auth.dart';
import 'package:firetrack360/models/service_request.dart';
import 'package:firetrack360/ui/pages/home/widgets/create_service_request_modal.dart'
    as home_widgets;
import 'package:flutter/material.dart';
import 'package:firetrack360/providers/ServiceRequestProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);
final pageSizeProvider = StateProvider<int>((ref) => 10);

class ServiceRequestsScreen extends HookConsumerWidget {
  const ServiceRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = useAuth();
    final userRole = authState.userRole;
    final serviceRequestsAsync = ref.watch(filteredServiceRequestsProvider);
    final currentPage = ref.watch(currentPageProvider);
    final pageSize = ref.watch(pageSizeProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Service Requests',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        ref
                            .read(serviceRequestNotifierProvider.notifier)
                            .refreshServiceRequests();
                      },
                    ),
                    if (userRole == 'CLIENT')
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                const home_widgets.CreateServiceRequestModal(),
                          ).then((_) {
                            ref
                                .read(serviceRequestNotifierProvider.notifier)
                                .refreshServiceRequests();
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search Bar
                Container(
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
                      hintText: 'Search service requests...',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.deepPurple),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      ref.read(searchQueryProvider.notifier).state = value;
                      // Reset to first page when searching
                      ref.read(currentPageProvider.notifier).state = 0;
                    },
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: serviceRequestsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading service requests',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () {
                        ref
                            .read(serviceRequestNotifierProvider.notifier)
                            .refreshServiceRequests();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (requests) {
                if (requests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Service Requests Found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Calculate pagination
                final totalPages = (requests.length / pageSize).ceil();
                final startIndex = currentPage * pageSize;
                final endIndex = startIndex + pageSize > requests.length
                    ? requests.length
                    : startIndex + pageSize;
                final pageItems = requests.sublist(startIndex, endIndex);

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Data Table
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 32,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(
                                      Colors.deepPurple.withOpacity(0.1)),
                                  headingTextStyle: const TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  dataRowMinHeight: 60,
                                  dataRowMaxHeight: 60,
                                  columnSpacing: 20,
                                  columns: const [
                                    DataColumn(
                                      label: Expanded(
                                        child: Text('TITLE'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text('STATUS'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text('TECHNICIAN'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text('DATE'),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text('ACTIONS'),
                                      ),
                                    ),
                                  ],
                                  rows: pageItems
                                      .map(
                                        (request) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                request.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            DataCell(
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(
                                                          request.status)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  request.status,
                                                  style: TextStyle(
                                                    color: _getStatusColor(
                                                        request.status),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                request.technician.phone ??
                                                    'No technician assigned',
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                DateFormat('MMM dd').format(
                                                    request.requestDate),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              IconButton(
                                                icon: const Icon(
                                                    Icons
                                                        .remove_red_eye_outlined,
                                                    size: 20,
                                                    color: Colors.deepPurple),
                                                onPressed: () {
                                                  // Handle view action
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                  //   ServiceRequestDetailScreen(request: request)));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Pagination Controls - Responsive Layout
                      if (isSmallScreen)
                        _buildSmallScreenPagination(
                          context,
                          ref,
                          currentPage,
                          totalPages,
                          pageSize,
                          startIndex,
                          endIndex,
                          requests.length,
                        )
                      else
                        _buildRegularPagination(
                          context,
                          ref,
                          currentPage,
                          totalPages,
                          pageSize,
                          startIndex,
                          endIndex,
                          requests.length,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallScreenPagination(
    BuildContext context,
    WidgetRef ref,
    int currentPage,
    int totalPages,
    int pageSize,
    int startIndex,
    int endIndex,
    int totalItems,
  ) {
    return Column(
      children: [
        // Records info and Page size selection
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Records info
            Text(
              'Showing ${startIndex + 1}-$endIndex of $totalItems',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            // Page size dropdown
            Row(
              children: [
                Text(
                  'Rows: ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                DropdownButton<int>(
                  value: pageSize,
                  underline: Container(),
                  isDense: true,
                  items: [5, 10, 15, 20].map((size) {
                    return DropdownMenuItem<int>(
                      value: size,
                      child: Text('$size'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(pageSizeProvider.notifier).state = value;
                      ref.read(currentPageProvider.notifier).state = 0;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Pagination buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.first_page, size: 20),
              onPressed: currentPage > 0
                  ? () {
                      ref.read(currentPageProvider.notifier).state = 0;
                    }
                  : null,
              color: currentPage > 0 ? Colors.deepPurple : Colors.grey,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 20),
              onPressed: currentPage > 0
                  ? () {
                      ref.read(currentPageProvider.notifier).state =
                          currentPage - 1;
                    }
                  : null,
              color: currentPage > 0 ? Colors.deepPurple : Colors.grey,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currentPage + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 20),
              onPressed: currentPage < totalPages - 1
                  ? () {
                      ref.read(currentPageProvider.notifier).state =
                          currentPage + 1;
                    }
                  : null,
              color: currentPage < totalPages - 1
                  ? Colors.deepPurple
                  : Colors.grey,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.last_page, size: 20),
              onPressed: currentPage < totalPages - 1
                  ? () {
                      ref.read(currentPageProvider.notifier).state =
                          totalPages - 1;
                    }
                  : null,
              color: currentPage < totalPages - 1
                  ? Colors.deepPurple
                  : Colors.grey,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegularPagination(
    BuildContext context,
    WidgetRef ref,
    int currentPage,
    int totalPages,
    int pageSize,
    int startIndex,
    int endIndex,
    int totalItems,
  ) {
    return Row(
      children: [
        // Records info
        Expanded(
          flex: 2,
          child: Text(
            'Showing ${startIndex + 1}-$endIndex of $totalItems',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        // Page size dropdown
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rows per page: ',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              DropdownButton<int>(
                value: pageSize,
                underline: Container(),
                items: [5, 10, 15, 20].map((size) {
                  return DropdownMenuItem<int>(
                    value: size,
                    child: Text('$size'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(pageSizeProvider.notifier).state = value;
                    ref.read(currentPageProvider.notifier).state = 0;
                  }
                },
              ),
            ],
          ),
        ),
        // Pagination buttons
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                onPressed: currentPage > 0
                    ? () {
                        ref.read(currentPageProvider.notifier).state = 0;
                      }
                    : null,
                color: currentPage > 0 ? Colors.deepPurple : Colors.grey,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage > 0
                    ? () {
                        ref.read(currentPageProvider.notifier).state =
                            currentPage - 1;
                      }
                    : null,
                color: currentPage > 0 ? Colors.deepPurple : Colors.grey,
                visualDensity: VisualDensity.compact,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${currentPage + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < totalPages - 1
                    ? () {
                        ref.read(currentPageProvider.notifier).state =
                            currentPage + 1;
                      }
                    : null,
                color: currentPage < totalPages - 1
                    ? Colors.deepPurple
                    : Colors.grey,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: currentPage < totalPages - 1
                    ? () {
                        ref.read(currentPageProvider.notifier).state =
                            totalPages - 1;
                      }
                    : null,
                color: currentPage < totalPages - 1
                    ? Colors.deepPurple
                    : Colors.grey,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
