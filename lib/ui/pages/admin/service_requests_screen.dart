import 'package:firetrack360/hooks/use_auth.dart';
import 'package:firetrack360/ui/pages/home/widgets/create_service_request_modal.dart'
    as home_widgets;
import 'package:flutter/material.dart';
import 'package:firetrack360/providers/ServiceRequestProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:firetrack360/generated/l10n.dart'; // Import localization

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
    final l10n = S.of(context)!; // Get localized strings

    return Scaffold(
      backgroundColor: Theme.of(context)
          .scaffoldBackgroundColor, // Use theme background color
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
              color: Theme.of(context)
                  .primaryColor, // Use primary color for header
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .shadowColor
                      .withOpacity(0.2), // Use theme shadow color
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary), // Use color on primary
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      l10n.serviceRequestsTitle, // Localized title
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary, // Use color on primary
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.refresh,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary), // Use color on primary
                      onPressed: () {
                        ref
                            .read(serviceRequestNotifierProvider.notifier)
                            .refreshServiceRequests();
                      },
                      tooltip: l10n.refreshTooltip, // Localized tooltip
                    ),
                    if (userRole == 'CLIENT')
                      IconButton(
                        icon: Icon(Icons.add,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary), // Use color on primary
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
                        tooltip: l10n
                            .createServiceRequestTooltip, // Localized tooltip
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, // Use theme card color
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .shadowColor
                            .withOpacity(0.1), // Use theme shadow color
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium, // Use theme text style
                    decoration: InputDecoration(
                      hintText:
                          l10n.searchServiceRequestsHint, // Localized hint text
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                              color: Theme.of(context)
                                  .hintColor), // Use theme hint color
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary), // Use secondary color for icon
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
              loading: () => Center(
                child: CircularProgressIndicator(
                  color:
                      Theme.of(context).primaryColor, // Use theme primary color
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Theme.of(context)
                            .colorScheme
                            .error, // Use theme error color
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.errorLoadingServiceRequests, // Localized error message
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium, // Use theme text style
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .hintColor), // Use theme text style and hint color
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .primaryColor, // Use theme primary color
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onPrimary, // Use color on primary
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
                        child: Text(l10n.retryButton), // Localized button text
                      ),
                    ],
                  ),
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
                          color: Theme.of(context)
                              .hintColor, // Use theme hint color
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noServiceRequestsFound, // Localized empty message
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium, // Use theme text style
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.adjustSearchOrFilters, // Localized hint text
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .hintColor), // Use theme text style and hint color
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
                                color: Theme.of(context)
                                    .cardColor, // Use theme card color
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .shadowColor
                                        .withOpacity(
                                            0.05), // Use theme shadow color
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor.withOpacity(
                                          0.1)), // Use primary color with opacity
                                  headingTextStyle: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor, // Use theme primary color
                                    fontWeight: FontWeight.bold,
                                  ),
                                  dataRowMinHeight: 60,
                                  dataRowMaxHeight: 60,
                                  columnSpacing: 20,
                                  columns: [
                                    DataColumn(
                                      label: Expanded(
                                        child:
                                            Text(l10n.columnTitle), // Localized
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                            l10n.columnStatus), // Localized
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                            l10n.columnTechnician), // Localized
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child:
                                            Text(l10n.columnDate), // Localized
                                      ),
                                    ),
                                    DataColumn(
                                      label: Expanded(
                                        child: Text(
                                            l10n.columnActions), // Localized
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
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ), // Use theme text style
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
                                                  _localizeStatus(
                                                      request.status,
                                                      l10n), // Localize status
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
                                                request.technician?.phone ??
                                                    l10n.noTechnicianAssigned, // Localized
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall, // Use theme text style
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                DateFormat('MMM dd').format(
                                                    request.requestDate),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall, // Use theme text style
                                              ),
                                            ),
                                            DataCell(
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons
                                                            .remove_red_eye_outlined,
                                                        size: 20,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary), // Use theme primary color
                                                    onPressed: () {
                                                      // Show client info dialog
                                                      _showServiceRequestDetailsDialog(
                                                          // Renamed for clarity
                                                          context,
                                                          request,
                                                          l10n); // Pass l10n
                                                    },
                                                    tooltip: l10n
                                                        .viewDetailsTooltip, // Localized tooltip
                                                  ),
                                                ],
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
                          l10n, // Pass l10n
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
                          l10n, // Pass l10n
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

  // Renamed and added l10n parameter
  void _showServiceRequestDetailsDialog(
      BuildContext context, dynamic request, S l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 500),
            color: Theme.of(context)
                .cardColor, // Use theme card color for dialog background
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity(0.1), // Use primary color with opacity
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.article_outlined,
                        color: Theme.of(context)
                            .primaryColor, // Use theme primary color
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.serviceRequestDetailsTitle, // Localized title
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.color,
                                ), // Use theme text style
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color), // Use theme text color
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Service Request Info
                _buildInfoSection(
                  l10n.requestInformationTitle, // Localized title
                  [
                    _buildInfoRow(l10n.titleLabel, request.title,
                        context), // Pass context for text style
                    _buildInfoRow(
                        l10n.statusLabel,
                        _localizeStatus(request.status, l10n),
                        context), // Localize and pass context
                    _buildInfoRow(
                        l10n.dateLabel,
                        DateFormat('MMM dd, yyyy').format(request.requestDate),
                        context), // Pass context
                    _buildInfoRow(l10n.descriptionLabel, request.description,
                        context), // Pass context
                  ],
                  context, // Pass context to section builder
                ),

                const SizedBox(height: 16),

                // Client Info
                _buildInfoSection(
                  l10n.clientInformationTitle, // Localized title
                  [
                    _buildInfoRow(
                        l10n.emailLabel,
                        request.client?.email ?? l10n.notAvailable,
                        context), // Localized and pass context
                    _buildInfoRow(
                        l10n.phoneLabel,
                        request.client?.phone ?? l10n.notAvailable,
                        context), // Localized and pass context
                  ],
                  context, // Pass context to section builder
                ),

                const SizedBox(height: 16),

                // Technician Info
                _buildInfoSection(
                  l10n.technicianInformationTitle, // Localized title
                  [
                    _buildInfoRow(
                        l10n.emailLabel,
                        request.technician?.email ?? l10n.notAvailable,
                        context), // Localized and pass context
                    _buildInfoRow(
                        l10n.phoneLabel,
                        request.technician?.phone ?? l10n.notAvailable,
                        context), // Localized and pass context
                  ],
                  context, // Pass context to section builder
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context)
                            .colorScheme
                            .onPrimary, // Use color on primary
                        backgroundColor: Theme.of(context)
                            .primaryColor, // Use theme primary color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8), // Adjusted padding
                        shape: RoundedRectangleBorder(
                          // Added shape for consistency
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(l10n.closeButton), // Localized button text
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(
      String title, List<Widget> rows, BuildContext context) {
    // Added context parameter
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor.withOpacity(
            0.05), // Use hoverColor with opacity for a subtle background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).dividerColor), // Use theme divider color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, // Use the localized section title
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Use theme primary color for section title
                ), // Use theme text style
          ),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    // Added context parameter
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label, // Use the localized label
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7), // Adjust opacity for label
                  ), // Use theme text style
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value, // Use the localized value
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium, // Use theme text style
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
    S l10n, // Added l10n parameter
  ) {
    return Column(
      children: [
        // Records info and Page size selection
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Records info
            Text(
              l10n.showingRecords(
                  startIndex + 1, endIndex, totalItems), // Localized
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.7),
                  ), // Use theme text style
            ),
            // Page size dropdown
            Row(
              children: [
                Text(
                  l10n.rowsLabel, // Localized
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.7),
                      ), // Use theme text style
                ),
                DropdownButton<int>(
                  value: pageSize,
                  underline: Container(),
                  isDense: true,
                  items: [5, 10, 15, 20].map((size) {
                    return DropdownMenuItem<int>(
                      value: size,
                      child: Text('$size',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium), // Use theme text style
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(pageSizeProvider.notifier).state = value;
                      ref.read(currentPageProvider.notifier).state = 0;
                    }
                  },
                  dropdownColor: Theme.of(context)
                      .cardColor, // Use theme card color for dropdown
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
              icon: Icon(Icons.first_page,
                  size: 20,
                  color: currentPage > 0
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor), // Use theme colors
              onPressed: currentPage > 0
                  ? () {
                      ref.read(currentPageProvider.notifier).state = 0;
                    }
                  : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.chevron_left,
                  size: 20,
                  color: currentPage > 0
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor), // Use theme colors
              onPressed: currentPage > 0
                  ? () {
                      ref.read(currentPageProvider.notifier).state =
                          currentPage - 1;
                    }
                  : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).primaryColor, // Use theme primary color
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currentPage + 1}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary, // Use color on primary
                      fontWeight: FontWeight.bold,
                    ), // Use theme text style
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.chevron_right,
                  size: 20,
                  color: currentPage < totalPages - 1
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor), // Use theme colors
              onPressed: currentPage < totalPages - 1
                  ? () {
                      ref.read(currentPageProvider.notifier).state =
                          currentPage + 1;
                    }
                  : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.last_page,
                  size: 20,
                  color: currentPage < totalPages - 1
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor), // Use theme colors
              onPressed: currentPage < totalPages - 1
                  ? () {
                      ref.read(currentPageProvider.notifier).state =
                          totalPages - 1;
                    }
                  : null,
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
    S l10n, // Added l10n parameter
  ) {
    return Row(
      children: [
        // Records info
        Expanded(
          flex: 2,
          child: Text(
            l10n.showingRecords(
                startIndex + 1, endIndex, totalItems), // Localized
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withOpacity(0.7),
                ), // Use theme text style
          ),
        ),
        // Page size dropdown
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.rowsPerPageLabel, // Localized
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withOpacity(0.7),
                    ), // Use theme text style
              ),
              DropdownButton<int>(
                value: pageSize,
                underline: Container(),
                items: [5, 10, 15, 20].map((size) {
                  return DropdownMenuItem<int>(
                    value: size,
                    child: Text('$size',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium), // Use theme text style
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(pageSizeProvider.notifier).state = value;
                    ref.read(currentPageProvider.notifier).state = 0;
                  }
                },
                dropdownColor: Theme.of(context)
                    .cardColor, // Use theme card color for dropdown
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
                icon: Icon(Icons.first_page,
                    color: currentPage > 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor), // Use theme colors
                onPressed: currentPage > 0
                    ? () {
                        ref.read(currentPageProvider.notifier).state = 0;
                      }
                    : null,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(Icons.chevron_left,
                    color: currentPage > 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor), // Use theme colors
                onPressed: currentPage > 0
                    ? () {
                        ref.read(currentPageProvider.notifier).state =
                            currentPage - 1;
                      }
                    : null,
                visualDensity: VisualDensity.compact,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).primaryColor, // Use theme primary color
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${currentPage + 1}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary, // Use color on primary
                        fontWeight: FontWeight.bold,
                      ), // Use theme text style
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right,
                    color: currentPage < totalPages - 1
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor), // Use theme colors
                onPressed: currentPage < totalPages - 1
                    ? () {
                        ref.read(currentPageProvider.notifier).state =
                            currentPage + 1;
                      }
                    : null,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(Icons.last_page,
                    color: currentPage < totalPages - 1
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor), // Use theme colors
                onPressed: currentPage < totalPages - 1
                    ? () {
                        ref.read(currentPageProvider.notifier).state =
                            totalPages - 1;
                      }
                    : null,
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

  // Helper to localize status strings
  String _localizeStatus(String status, S l10n) {
    switch (status.toLowerCase()) {
      case 'pending':
        return l10n.statusPending;
      case 'in progress':
        return l10n.statusInProgress;
      case 'completed':
        return l10n.statusCompleted;
      case 'cancelled':
        return l10n.statusCancelled;
      default:
        return status;
    }
  }
}
