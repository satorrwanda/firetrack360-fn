import 'package:firetrack360/generated/l10n.dart';
import 'package:firetrack360/models/service_request.dart';
import 'package:firetrack360/providers/ServiceRequestProvider.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    final primaryColor = Theme.of(context).primaryColor;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final dialogBackgroundColor =
        isDarkMode ? Colors.grey.shade900 : Colors.white;

    final List<String> availableStatuses = [
      'REQUESTED',
      'In Progress',
      'Completed',
      'Cancelled',
    ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: dialogBackgroundColor,
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
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.newStatusLabel,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
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
                fillColor: isDarkMode
                    ? Colors.deepPurple.shade900
                    : Colors.grey.shade100,
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              dropdownColor: dialogBackgroundColor,
              style: TextStyle(color: textColor, fontSize: 16),
              iconEnabledColor: primaryColor,
              items: availableStatuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(
                    _localizeStatus(status, l10n),
                    style: TextStyle(color: textColor),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
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
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.cancelButton),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectedStatus == null ||
                          _selectedStatus == widget.request.status
                      ? null
                      : () async {
                          if (_selectedStatus != null) {
                            await ref
                                .read(serviceRequestNotifierProvider.notifier)
                                .updateServiceRequestStatus(
                                    widget.request.id, _selectedStatus!);

                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.statusUpdateSuccess(
                                      _localizeStatus(_selectedStatus!, l10n))),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: onPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(l10n.updateButton),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
