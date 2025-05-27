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
                loading: () => Center(
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
                          _buildSmallScreenPagination(
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
                          _buildRegularPagination(
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBackgroundColor =
        isDarkMode ? Colors.deepPurple.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor =
        isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final primaryColor = Theme.of(context).primaryColor;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final dividerColor = Theme.of(context).dividerColor;

    // The main list is already loaded to show the dialog,
    // so individual details within the dialog are not in a separate loading state based on the main list.
    // If you were fetching individual details in the dialog, you'd use a separate provider and its isLoading state here.

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
            color: cardBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.article_outlined,
                        color: primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.serviceRequestDetailsTitle,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.close, color: textColor.withOpacity(0.7)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildInfoSection(
                    l10n.requestInformationTitle,
                    [
                      // Removed isLoading check and loader simulation
                      _buildInfoRow(l10n.titleLabel, request.title, context,
                          textColor, secondaryTextColor, dividerColor),
                      _buildInfoRow(
                          l10n.statusLabel,
                          _localizeStatus(request.status, l10n),
                          context,
                          textColor,
                          secondaryTextColor,
                          dividerColor),
                      _buildInfoRow(
                          l10n.dateLabel,
                          DateFormat('MMM dd, yyyy')
                              .format(request.requestDate),
                          context,
                          textColor,
                          secondaryTextColor,
                          dividerColor),
                      _buildInfoRow(l10n.descriptionLabel, request.description,
                          context, textColor, secondaryTextColor, dividerColor),
                    ],
                    context,
                    textColor,
                    primaryColor,
                    dividerColor,
                    isDarkMode),
                const SizedBox(height: 16),
                _buildInfoSection(
                    l10n.clientInformationTitle,
                    [
                      // Removed isLoading check and loader simulation
                      _buildInfoRow(
                          l10n.emailLabel,
                          request.client?.email ?? l10n.notAvailable,
                          context,
                          textColor,
                          secondaryTextColor,
                          dividerColor),
                      _buildInfoRow(
                          l10n.phoneLabel,
                          request.client?.phone ?? l10n.notAvailable,
                          context,
                          textColor,
                          secondaryTextColor,
                          dividerColor),
                    ],
                    context,
                    textColor,
                    primaryColor,
                    dividerColor,
                    isDarkMode),
                const SizedBox(height: 16),
                _buildInfoSection(
                    l10n.technicianInformationTitle,
                    [
                      // Removed isLoading check and loader simulation
                      _buildInfoRow(
                          l10n.emailLabel,
                          request.technician?.email ?? l10n.notAvailable,
                          context,
                          textColor,
                          secondaryTextColor,
                          dividerColor),
                      _buildInfoRow(
                          l10n.phoneLabel,
                          request.technician?.phone ?? l10n.notAvailable,
                          context,
                          textColor,
                          secondaryTextColor,
                          dividerColor),
                    ],
                    context,
                    textColor,
                    primaryColor,
                    dividerColor,
                    isDarkMode),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: onPrimaryColor,
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(l10n.closeButton),
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
      String title,
      List<Widget> rows,
      BuildContext context,
      Color textColor,
      Color primaryColor,
      Color dividerColor,
      bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context,
      Color textColor, Color secondaryTextColor, Color dividerColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: secondaryTextColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: textColor),
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
    S l10n,
  ) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final secondaryTextColor =
        Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7);
    final primaryColor = Theme.of(context).primaryColor;
    final disabledColor = Theme.of(context).disabledColor;
    final cardColor = Theme.of(context).cardColor;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.showingRecords(
                  startIndex + 1, endIndex, totalItems, pageSize),
              style: TextStyle(color: secondaryTextColor),
            ),
            Row(
              children: [
                Text(
                  l10n.rowsLabel,
                  style: TextStyle(color: secondaryTextColor),
                ),
                DropdownButton<int>(
                  value: pageSize,
                  underline: Container(),
                  isDense: true,
                  items: [5, 10, 15, 20].map((size) {
                    return DropdownMenuItem<int>(
                      value: size,
                      child: Text('$size', style: TextStyle(color: textColor)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(pageSizeProvider.notifier).state = value;
                      ref.read(currentPageProvider.notifier).state = 0;
                    }
                  },
                  dropdownColor: cardColor,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.first_page,
                  size: 20,
                  color: currentPage > 0 ? primaryColor : disabledColor),
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
                  color: currentPage > 0 ? primaryColor : disabledColor),
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
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currentPage + 1}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.chevron_right,
                  size: 20,
                  color: currentPage < totalPages - 1
                      ? primaryColor
                      : disabledColor),
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
                      ? primaryColor
                      : disabledColor),
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
    S l10n,
  ) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final secondaryTextColor =
        Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7);
    final primaryColor = Theme.of(context).primaryColor;
    final disabledColor = Theme.of(context).disabledColor;
    final cardColor = Theme.of(context).cardColor;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            l10n.showingRecords(startIndex + 1, endIndex, totalItems, pageSize),
            style: TextStyle(color: secondaryTextColor),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.rowsPerPageLabel,
                style: TextStyle(color: secondaryTextColor),
              ),
              DropdownButton<int>(
                value: pageSize,
                underline: Container(),
                items: [5, 10, 15, 20].map((size) {
                  return DropdownMenuItem<int>(
                    value: size,
                    child: Text('$size', style: TextStyle(color: textColor)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(pageSizeProvider.notifier).state = value;
                    ref.read(currentPageProvider.notifier).state = 0;
                  }
                },
                dropdownColor: cardColor,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.first_page,
                    color: currentPage > 0 ? primaryColor : disabledColor),
                onPressed: currentPage > 0
                    ? () {
                        ref.read(currentPageProvider.notifier).state = 0;
                      }
                    : null,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                icon: Icon(Icons.chevron_left,
                    color: currentPage > 0 ? primaryColor : disabledColor),
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
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${currentPage + 1}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right,
                    color: currentPage < totalPages - 1
                        ? primaryColor
                        : disabledColor),
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
                        ? primaryColor
                        : disabledColor),
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
