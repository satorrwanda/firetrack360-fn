import 'package:firetrack360/ui/pages/home/widgets/pagination.dart';
import 'package:firetrack360/ui/pages/home/widgets/service_request_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firetrack360/hooks/use_auth.dart';
import 'package:firetrack360/ui/pages/home/widgets/create_service_request_modal.dart'
    as home_widgets;
import 'package:firetrack360/providers/ServiceRequestProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:firetrack360/generated/l10n.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);
final pageSizeProvider = StateProvider<int>((ref) => 10);
final searchQueryProvider = StateProvider<String>((ref) => '');

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
    final l10n = S.of(context)!;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appBarColor =
        isDarkMode ? Colors.deepPurple.shade900 : Colors.deepPurple;
    final gradientStartColor =
        isDarkMode ? Colors.deepPurple.shade900 : Colors.deepPurple.shade700;
    final gradientEndColor =
        isDarkMode ? Colors.black : Colors.deepPurple.shade400;
    final cardBackgroundColor =
        isDarkMode ? Colors.deepPurple.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor =
        isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final primaryColor = Theme.of(context).primaryColor;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              gradientStartColor,
              gradientEndColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                color: appBarColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .shadowColor
                        .withOpacity(isDarkMode ? 0.4 : 0.2),
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
                        icon: Icon(Icons.arrow_back, color: onPrimaryColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        l10n.serviceRequestsTitle,
                        style: TextStyle(
                          color: onPrimaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.refresh, color: onPrimaryColor),
                        onPressed: () {
                          ref
                              .read(serviceRequestNotifierProvider.notifier)
                              .refreshServiceRequests();
                        },
                        tooltip: l10n.refreshTooltip,
                      ),
                      if (userRole == 'CLIENT')
                        IconButton(
                          icon: Icon(Icons.add, color: onPrimaryColor),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const home_widgets
                                  .CreateServiceRequestModal(),
                            ).then((_) {
                              ref
                                  .read(serviceRequestNotifierProvider.notifier)
                                  .refreshServiceRequests();
                            });
                          },
                          tooltip: l10n.createServiceRequestTooltip,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .shadowColor
                              .withOpacity(isDarkMode ? 0.3 : 0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: l10n.searchServiceRequestsHint,
                        hintStyle: TextStyle(color: secondaryTextColor),
                        prefixIcon: Icon(Icons.search, color: textColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(searchQueryProvider.notifier).state = value;
                        ref.read(currentPageProvider.notifier).state = 0;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: serviceRequestsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
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
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.errorLoadingServiceRequests,
                          style: TextStyle(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: TextStyle(
                              color: secondaryTextColor, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: onPrimaryColor,
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
                          child: Text(l10n.retryButton),
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
                            color: secondaryTextColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noServiceRequestsFound,
                            style: TextStyle(color: textColor),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.adjustSearchOrFilters,
                            style: TextStyle(
                                color: secondaryTextColor, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }

                  final totalPages = (requests.length / pageSize).ceil();
                  final startIndex = currentPage * pageSize;
                  final endIndex = startIndex + pageSize > requests.length
                      ? requests.length
                      : startIndex + pageSize;
                  final pageItems = requests.sublist(startIndex, endIndex);

                  // Show loader instead of the table if data is loading
                  if (serviceRequestsAsync.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.of(context).size.width - 32,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .shadowColor
                                          .withOpacity(isDarkMode ? 0.3 : 0.05),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(
                                        primaryColor.withOpacity(0.1)),
                                    headingTextStyle: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    dataRowMinHeight: 60,
                                    dataRowMaxHeight: 60,
                                    columnSpacing: 20,
                                    columns: [
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(l10n.columnTitle),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(l10n.columnStatus),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(l10n.columnTechnician),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(l10n.columnDate),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(l10n.columnActions),
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
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              DataCell(
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(
                                                            request.status)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    _localizeStatus(
                                                        request.status, l10n),
                                                    style: TextStyle(
                                                      color: _getStatusColor(
                                                          request.status),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  request.technician?.phone ??
                                                      l10n.noTechnicianAssigned,
                                                  style: TextStyle(
                                                      color:
                                                          secondaryTextColor),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  DateFormat('MMM dd').format(
                                                      request.requestDate),
                                                  style: TextStyle(
                                                      color:
                                                          secondaryTextColor),
                                                ),
                                              ),
                                              DataCell(
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons
                                                              .remove_red_eye_outlined,
                                                          size: 20,
                                                          color: primaryColor),
                                                      onPressed: () {
                                                        _showServiceRequestDetailsDialog(
                                                            context,
                                                            request,
                                                            l10n);
                                                      },
                                                      tooltip: l10n
                                                          .viewDetailsTooltip,
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
                        if (isSmallScreen)
                          buildSmallScreenPagination(
                            context,
                            ref,
                            currentPage,
                            totalPages,
                            pageSize,
                            startIndex,
                            endIndex,
                            requests.length,
                            l10n,
                          )
                        else
                          buildRegularPagination(
                            context,
                            ref,
                            currentPage,
                            totalPages,
                            pageSize,
                            startIndex,
                            endIndex,
                            requests.length,
                            l10n,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceRequestDetailsDialog(
      BuildContext context, dynamic request, S l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ServiceRequestDetailsDialog(request: request, l10n: l10n);
      },
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
