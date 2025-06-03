import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/models/service_request.dart';
import 'package:firetrack360/providers/ServiceRequestProvider.dart';
import 'package:firetrack360/providers/ServiceRequestUpdater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceRequestStatusUpdateDialog extends ConsumerStatefulWidget {
  final ServiceRequest request;

  const ServiceRequestStatusUpdateDialog({
    super.key,
    required this.request,
  });

  @override
  ConsumerState<ServiceRequestStatusUpdateDialog> createState() =>
      _ServiceRequestStatusUpdateDialogState();
}

class _ServiceRequestStatusUpdateDialogState
    extends ConsumerState<ServiceRequestStatusUpdateDialog> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.request.status;
  }

  String _localizeStatus(String status, S l10n) {
    switch (status.toUpperCase()) {
      case 'REQUESTED':
        return l10n.statusRequested;
      case 'ASSIGNED':
        return l10n.statusAssigned;
      case 'SCHEDULED':
        return l10n.statusScheduled;
      case 'IN_PROGRESS':
        return l10n.statusInProgress;
      case 'COMPLETED':
        return l10n.statusCompleted;
      case 'CANCELLED':
        return l10n.statusCancelled;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final primaryColor = Theme.of(context).primaryColor;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Use Theme.of(context).colorScheme for more robust dark mode colors
    final Color currentTextColor = Theme.of(context).colorScheme.onSurface;
    final Color currentDialogBackgroundColor =
        Theme.of(context).colorScheme.surface;
    final Color disabledColor = Theme.of(context)
        .colorScheme
        .onSurface
        .withOpacity(0.38); // Standard disabled color

    final updaterState = ref.watch(serviceRequestUpdaterProvider);

    final List<String> availableStatuses = [
      'REQUESTED',
      'ASSIGNED',
      'SCHEDULED',
      'IN_PROGRESS',
      'COMPLETED',
      'CANCELLED'
    ];

    final bool isSelectedStatusCompleted =
        _selectedStatus?.toUpperCase() == 'COMPLETED';

    final bool isAlreadyCompleted =
        widget.request.status.toUpperCase() == 'COMPLETED';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor:
          currentDialogBackgroundColor, // Use theme's surface color
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.updateServiceRequestStatus,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '${l10n.titleLabel}: ${widget.request.title}',
              style: TextStyle(
                  fontSize: 16,
                  color: currentTextColor), // Use currentTextColor
            ),
            const SizedBox(height: 16),
            Text(
              l10n.newStatusLabel,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: currentTextColor), // Use currentTextColor
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                // Adjust fillColor for dark mode for the input field itself
                fillColor: isDarkMode
                    ? Colors.grey.shade800
                    : Colors.grey.shade100,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              dropdownColor:
                  currentDialogBackgroundColor, // Use theme's surface color for dropdown menu
              style: TextStyle(
                  color: currentTextColor,
                  fontSize: 16), // Use currentTextColor for selected value text
              iconEnabledColor: primaryColor,
              items: availableStatuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  enabled: !(isAlreadyCompleted &&
                      status.toUpperCase() != 'COMPLETED'),
                  child: Text(
                    _localizeStatus(status, l10n),
                    style: TextStyle(
                        color: !(isAlreadyCompleted &&
                                status.toUpperCase() != 'COMPLETED')
                            ? currentTextColor // Use currentTextColor
                            : disabledColor), // Use theme's disabled color
                  ),
                );
              }).toList(),
              onChanged: isAlreadyCompleted
                  ? null
                  : (newValue) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: updaterState.isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor, // This should adapt well
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.cancelButton),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: updaterState.isLoading ||
                          _selectedStatus == null ||
                          _selectedStatus == widget.request.status ||
                          isAlreadyCompleted
                      ? null
                      : () async {
                          if (_selectedStatus != null) {
                            try {
                              if (isSelectedStatusCompleted) {
                                await ref
                                    .read(
                                        serviceRequestUpdaterProvider.notifier)
                                    .completeService(widget.request.id);

                                await ref
                                    .read(
                                        serviceRequestNotifierProvider.notifier)
                                    .refreshServiceRequests();

                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "service Completed Successfully"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.statusUpdateSuccess(
                                          _localizeStatus(
                                              _selectedStatus!, l10n))),
                                      backgroundColor: Colors.blue,
                                    ),
                                  );
                                  await ref
                                      .read(serviceRequestNotifierProvider
                                          .notifier)
                                      .refreshServiceRequests();
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        e.toString()), // Direct error message
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // This adapts
                    foregroundColor: onPrimaryColor, // This adapts
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: updaterState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors
                                .white, // White is usually good for dark mode progress indicators
                          ),
                        )
                      : Text(l10n.updateButton),
                ),
              ],
            ),
            // Message when already completed, ensure it's visible in dark mode
            if (isAlreadyCompleted &&
                !updaterState
                    .isLoading) // Show message only if not currently loading an update
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Text(
                    " ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green.shade700),
                  ),
                ),
              ),
            if (updaterState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  updaterState.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
